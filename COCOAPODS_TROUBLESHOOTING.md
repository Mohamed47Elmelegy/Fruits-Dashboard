# 🔧 CocoaPods Troubleshooting Guide

## المشكلة
```
CocoaPods could not find compatible versions for pod "cloud_firestore":
In Podfile:
  cloud_firestore (from `.symlinks/plugins/cloud_firestore/ios`)
Specs satisfying the `cloud_firestore` dependency were found, but they required a higher minimum iOS version.
```

## الحلول

### 1. الحل التلقائي (مستحسن)

#### للويندوز (PowerShell):
```powershell
cd ios
.\clean_and_install_pods.ps1
```

#### للماك/لينكس (Bash):
```bash
cd ios
chmod +x clean_and_install_pods.sh
./clean_and_install_pods.sh
```

### 2. الحل اليدوي

#### الخطوة 1: تنظيف المشروع
```bash
flutter clean
flutter pub get
```

#### الخطوة 2: حذف ملفات CocoaPods
```bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
```

#### الخطوة 3: تحديث Podfile
تأكد من أن ملف `ios/Podfile` يحتوي على:
```ruby
platform :ios, '13.0'
```

#### الخطوة 4: إعادة تثبيت CocoaPods
```bash
pod install --repo-update
```

### 3. التحقق من الإصدارات

#### تحقق من إصدار CocoaPods:
```bash
pod --version
```

#### تحقق من إصدار Flutter:
```bash
flutter --version
```

#### تحقق من إصدار Firebase:
```bash
flutter pub deps | grep firebase
```

### 4. حلول إضافية

#### إذا استمرت المشكلة:

1. **تحديث CocoaPods:**
   ```bash
   sudo gem install cocoapods
   ```

2. **تحديث Flutter:**
   ```bash
   flutter upgrade
   ```

3. **تحديث Firebase packages:**
   ```bash
   flutter pub upgrade
   ```

4. **حذف cache:**
   ```bash
   flutter clean
   rm -rf ~/.pub-cache
   flutter pub get
   ```

### 5. إعدادات Xcode

#### تأكد من إعدادات Xcode:
1. افتح `ios/Runner.xcworkspace` في Xcode
2. اختر مشروع Runner
3. في Build Settings، ابحث عن "iOS Deployment Target"
4. تأكد من أنه مضبوط على 13.0 أو أعلى

### 6. مشاكل شائعة

#### مشكلة: "No such file or directory"
```bash
# حل: إعادة إنشاء symlinks
cd ios
flutter pub get
pod install
```

#### مشكلة: "Permission denied"
```bash
# حل: إعطاء صلاحيات
chmod +x ios/clean_and_install_pods.sh
```

#### مشكلة: "Network error"
```bash
# حل: استخدام mirror أو VPN
pod install --repo-update --verbose
```

## نصائح مهمة

1. **استخدم دائماً `Runner.xcworkspace`** وليس `Runner.xcodeproj`
2. **تأكد من تحديث Flutter و CocoaPods** بانتظام
3. **احتفظ بنسخة احتياطية** قبل إجراء تغييرات كبيرة
4. **استخدم Git** لتتبع التغييرات

## الدعم

إذا استمرت المشكلة، يرجى:
1. مشاركة رسالة الخطأ الكاملة
2. مشاركة محتوى ملف `ios/Podfile`
3. مشاركة إصدارات Flutter و CocoaPods

---

**ملاحظة:** هذا الدليل مخصص لحل مشاكل CocoaPods مع Firebase في Flutter. تأكد من اتباع الخطوات بالترتيب المذكور. 