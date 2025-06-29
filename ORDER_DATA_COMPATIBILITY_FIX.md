# Order Data Compatibility Fix

## المشكلة
كانت هناك مشكلة في عرض الطلبات في التطبيق الإداري (Dashboard) بسبب عدم توافق هيكل البيانات بين التطبيق الرئيسي والتطبيق الإداري.

## رسالة الخطأ
```
OrderCubit Change { currentState: OrderFailure(type 'Timestamp' is not a subtype of type 'String'), nextState: OrderLoading() }
```

## سبب المشكلة
1. **التطبيق الرئيسي** يحفظ البيانات كالتالي:
   - `createdAt`: string (مثل "2025-06-29T19:57:27.610682")
   - `createdAtTimestamp`: number (مثل 1751219847620)
   - `updatedAt`: string

2. **Firestore** أحياناً يحول `createdAt` من string إلى `Timestamp` object

3. **التطبيق الإداري** كان يحاول التعامل مع `createdAt` كـ string فقط، مما يسبب خطأ عند استقبال `Timestamp`

## الحل المطبق

### 1. تحديث `OrderModel.fromJson`
```dart
// Handle createdAt field - prioritize createdAtTimestamp, then handle createdAt
String createdAtString;
if (json['createdAtTimestamp'] != null) {
  // Use createdAtTimestamp if available (number) - this is the most reliable
  final timestamp = json['createdAtTimestamp'] as int;
  createdAtString = DateTime.fromMillisecondsSinceEpoch(timestamp).toIso8601String();
} else if (json['createdAt'] != null) {
  // Handle createdAt field - check if it's Timestamp or String
  final createdAt = json['createdAt'];
  if (createdAt is Timestamp) {
    // If it's a Firestore Timestamp, convert to string
    createdAtString = createdAt.toDate().toIso8601String();
  } else if (createdAt is String) {
    // If it's already a string, use it directly
    createdAtString = createdAt;
  } else {
    // Fallback to current time if createdAt is neither Timestamp nor String
    createdAtString = DateTime.now().toIso8601String();
  }
} else {
  // Fallback to current time if no createdAt field exists
  createdAtString = DateTime.now().toIso8601String();
}
```

### 2. تحديث `OrderStatusHistoryModel.fromJson`
```dart
factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
  final updatedAt = json['updatedAt'];
  DateTime updatedAtDateTime;
  if (updatedAt is Timestamp) {
    // If it's a Firestore Timestamp, convert to DateTime
    updatedAtDateTime = updatedAt.toDate();
  } else if (updatedAt is String) {
    try {
      // If it's a string, try to parse it
      updatedAtDateTime = DateTime.parse(updatedAt);
    } catch (e) {
      // If parsing fails, use current time
      updatedAtDateTime = DateTime.now();
    }
  } else {
    // Fallback to current time if updatedAt is neither Timestamp nor String
    updatedAtDateTime = DateTime.now();
  }
  return OrderStatusHistoryModel(
    status: json['status'] ?? '',
    updatedBy: json['updatedBy'] ?? '',
    updatedAt: updatedAtDateTime,
    notes: json['notes'],
  );
}
```

## الفروق بين التطبيقين

### التطبيق الرئيسي (Fruit App)
- يحفظ `createdAt` كـ string
- يضيف `createdAtTimestamp` كـ number للترتيب
- يضيف `updatedAt` كـ string

### التطبيق الإداري (Dashboard)
- يتعامل مع كلا النوعين (string و Timestamp)
- يفضل استخدام `createdAtTimestamp` للدقة
- يتعامل مع `lastUpdated` و `updatedAt`

## النتيجة
- تم حل مشكلة عرض الطلبات في التطبيق الإداري
- أصبح التطبيق متوافق مع جميع أنواع البيانات
- تحسين التعامل مع الأخطاء في parsing التواريخ

## اختبار الحل
1. تأكد من أن الطلبات تظهر في التطبيق الإداري
2. تأكد من أن التواريخ تظهر بشكل صحيح
3. تأكد من أن تحديث حالة الطلب يعمل بشكل صحيح 