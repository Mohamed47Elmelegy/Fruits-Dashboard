# 🔧 حل مشكلة CocoaPods مع Firebase

## المشكلة
```
CocoaPods could not find compatible versions for pod "cloud_firestore":
In Podfile:
  cloud_firestore (from `.symlinks/plugins/cloud_firestore/ios`)
Specs satisfying the `cloud_firestore` dependency were found, but they required a higher minimum iOS version.
```

## الحل السريع

### 1. تنظيف المشروع
```bash
flutter clean
flutter pub get
```

### 2. حذف ملفات CocoaPods
```bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
```

### 3. إعادة تثبيت CocoaPods
```bash
pod install --repo-update
```

## إذا لم يعمل الحل أعلاه

### تحديث Podfile
تأكد من أن ملف `ios/Podfile` يحتوي على:
```ruby
platform :ios, '13.0'
```

### تحديث إعدادات Xcode
1. افتح `ios/Runner.xcworkspace` في Xcode
2. اختر مشروع Runner
3. في Build Settings، ابحث عن "iOS Deployment Target"
4. تأكد من أنه مضبوط على 13.0 أو أعلى

## نصائح مهمة

- ✅ استخدم دائماً `Runner.xcworkspace` وليس `Runner.xcodeproj`
- ✅ تأكد من تحديث Flutter و CocoaPods بانتظام
- ✅ إذا استمرت المشكلة، جرب `pod install --repo-update --verbose`

## الدعم

إذا استمرت المشكلة، يرجى مشاركة:
1. رسالة الخطأ الكاملة
2. محتوى ملف `ios/Podfile`
3. إصدارات Flutter و CocoaPods

---

**ملاحظة:** هذا الحل مخصص لمشاكل CocoaPods مع Firebase في Flutter. 