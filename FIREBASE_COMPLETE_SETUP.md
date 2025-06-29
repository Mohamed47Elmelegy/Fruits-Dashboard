# 🔥 Firebase Complete Setup Guide

## 📱 iOS App Configuration

### App Details:
- **App ID**: `1:244051247756:ios:8b30d372af9272647c71a9`
- **Bundle ID**: `com.example.furuteAppDashbord`
- **Project ID**: `furute-fefa1`
- **Storage Bucket**: `furute-fefa1.firebasestorage.app`

## ✅ Configuration Files Status

### 1. GoogleService-Info.plist ✅
- ✅ Updated with correct iOS configuration
- ✅ All required keys present
- ✅ Bundle ID matches

### 2. firebase_options.dart ✅
- ✅ Generated and configured
- ✅ iOS options properly set

## 🚀 Required Firebase Console Setup

### 1. **Firestore Database Setup**

#### إنشاء قاعدة البيانات:
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/project/furute-fefa1)
2. اختر **Firestore Database**
3. اضغط **Create Database**
4. اختر **Start in test mode**
5. اختر الموقع: **europe-west1 (Belgium)**

#### إعداد قواعد الأمان:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // المستخدمين
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // المنتجات
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
    
    // الطلبات
    match /orders/{orderId} {
      allow read: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         exists(/databases/$(database)/documents/admins/$(request.auth.uid)));
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
    
    // الأدمن
    match /admins/{adminId} {
      allow read, write: if request.auth != null && request.auth.uid == adminId;
    }
    
    // الإحصائيات
    match /analytics/{docId} {
      allow read, write: if request.auth != null && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
    
    // إعدادات التطبيق
    match /appSettings/{docId} {
      allow read: if true;
      allow write: if request.auth != null && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
  }
}
```

### 2. **Authentication Setup**

#### تفعيل Authentication:
1. اذهب إلى **Authentication** في Firebase Console
2. اضغط **Get Started**
3. فعّل **Email/Password** provider
4. أضف المستخدم الأول:

```
Email: mohamed@gmail.com
Password: password
```

### 3. **Storage Setup**

#### إنشاء Storage:
1. اذهب إلى **Storage** في Firebase Console
2. اضغط **Get Started**
3. اختر **Start in test mode**
4. Bucket: `furute-fefa1.firebasestorage.app`

#### قواعد Storage:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // صور المنتجات
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && 
        firestore.exists(/databases/(default)/documents/admins/$(request.auth.uid));
    }
    
    // صور المستخدمين
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 4. **Required Indexes**

#### إنشاء الفهارس المطلوبة:

1. **Products Index:**
   - Collection: `products`
   - Fields: `isActive` (Ascending), `createdAt` (Descending)

2. **Orders Index:**
   - Collection: `orders`
   - Fields: `userId` (Ascending), `createdAt` (Descending)

3. **Orders by Status:**
   - Collection: `orders`
   - Fields: `status` (Ascending), `createdAt` (Descending)

## 📊 Initial Data Setup

### 1. **Create Admin User**

```javascript
// في مجموعة admins، أضف وثيقة جديدة
Collection: admins
Document ID: [UID من Authentication]
{
  "uid": "[UID]",
  "email": "mohamed@gmail.com",
  "name": "Mohamed Admin",
  "role": "admin",
  "createdAt": [timestamp],
  "isActive": true
}
```

### 2. **App Settings**

```javascript
// في مجموعة appSettings
Collection: appSettings
Document ID: general
{
  "appName": "Fruit App Dashboard",
  "version": "1.0.5",
  "maintenanceMode": false,
  "deliveryFee": 5.0,
  "minOrderAmount": 10.0,
  "currency": "USD",
  "supportEmail": "support@furute.com",
  "supportPhone": "+1234567890",
  "createdAt": [timestamp],
  "updatedAt": [timestamp]
}
```

### 3. **Sample Products**

```javascript
// في مجموعة products، أضف منتجات تجريبية
Collection: products
Document ID: [auto-generated]
{
  "productName": "تفاح أحمر",
  "productPrice": 2.99,
  "productCode": "APP001",
  "productDescription": "تفاح أحمر طازج عضوي من أفضل المزارع",
  "isFeatured": true,
  "isActive": true,
  "category": "fruits",
  "calories": 95,
  "unitAmount": "1 kg",
  "productRating": 4.5,
  "ratingCount": 10,
  "isOrganic": true,
  "imageUrl": "https://example.com/apple.jpg",
  "sellingCount": 0,
  "createdAt": [timestamp],
  "updatedAt": [timestamp],
  "createdBy": "[admin UID]"
}
```

## 🔧 Testing Configuration

### 1. **Test Firestore Connection**

```dart
// أضف هذا الكود في main.dart للاختبار
Future<void> testFirestoreConnection() async {
  try {
    final testDoc = await FirebaseFirestore.instance
        .collection('test')
        .add({
          'test': 'connection',
          'timestamp': FieldValue.serverTimestamp(),
          'platform': 'iOS'
        });
    print('✅ Firestore connection successful: ${testDoc.id}');
    
    // Clean up test document
    await testDoc.delete();
  } catch (e) {
    print('❌ Firestore connection failed: $e');
  }
}
```

### 2. **Test Authentication**

```dart
// اختبار تسجيل الدخول
Future<void> testAuthentication() async {
  try {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: 'mohamed@gmail.com',
          password: 'password',
        );
    print('✅ Authentication successful: ${userCredential.user?.uid}');
  } catch (e) {
    print('❌ Authentication failed: $e');
  }
}
```

## 📱 iOS Build Commands

### Clean Build:
```bash
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter build ios --release --no-codesign
```

### Development Build:
```bash
flutter run --release
```

## 🔍 Troubleshooting

### Common Issues:

1. **"Permission denied" Error:**
   - تأكد من إعداد قواعد الأمان
   - تحقق من تسجيل دخول المستخدم

2. **"Network error" Error:**
   - تحقق من اتصال الإنترنت
   - تأكد من صحة API keys

3. **"Index not found" Error:**
   - أنشئ الفهارس المطلوبة
   - انتظر بضع دقائق لتفعيل الفهارس

4. **"App not configured" Error:**
   - تأكد من وجود GoogleService-Info.plist
   - تحقق من Bundle ID

## ✅ Checklist

- [ ] إنشاء Firestore Database
- [ ] إعداد قواعد الأمان
- [ ] تفعيل Authentication
- [ ] إعداد Storage
- [ ] إنشاء الفهارس المطلوبة
- [ ] إضافة حساب الأدمن
- [ ] إضافة إعدادات التطبيق
- [ ] إضافة منتجات تجريبية
- [ ] اختبار الاتصال
- [ ] اختبار Authentication

## 🚀 Next Steps

1. **Monitor Performance:** استخدم Firebase Console لمراقبة الأداء
2. **Add Analytics:** فعّل Firebase Analytics
3. **Setup Notifications:** أضف Cloud Messaging
4. **Backup Strategy:** فعّل النسخ الاحتياطي التلقائي
5. **Security Audit:** راجع قواعد الأمان بانتظام

---

## 🎉 Setup Complete!

بعد إكمال هذه الإعدادات، سيعمل تطبيقك بشكل مثالي مع Firebase! 🚀 