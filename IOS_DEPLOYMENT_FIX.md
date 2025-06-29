# حل مشكلة iOS Deployment Target للـ Firebase

## المشكلة
```
Error: The plugin "cloud_firestore" requires a higher minimum iOS deployment version than your application is targeting.
```

## السبب
Firebase يتطلب iOS deployment target 13.0 على الأقل، بينما المشروع كان يستخدم 12.0.

## الحلول المطبقة

### 1. تحديث Podfile
**الملف:** `ios/Podfile`
```ruby
# تغيير من
platform :ios, '12.0'

# إلى
platform :ios, '13.0'
```

### 2. تحديث project.pbxproj
**الملف:** `ios/Runner.xcodeproj/project.pbxproj`
```objc
// تغيير جميع قيم
IPHONEOS_DEPLOYMENT_TARGET = 12.0;

// إلى
IPHONEOS_DEPLOYMENT_TARGET = 13.0;
```

### 3. إنشاء Script للتحديث التلقائي
**الملف:** `ios/update_deployment_target.sh`
- script يقوم بتحديث جميع الملفات تلقائياً
- يتحقق من وجود الملفات قبل التحديث
- يعرض رسائل تأكيد لكل خطوة

### 4. تحديث GitHub Actions
**الملف:** `.github/workflows/dart.yml`
```yaml
# إضافة خطوة تحديث deployment target
- name: Update iOS deployment target
  run: |
    cd ios
    chmod +x update_deployment_target.sh
    ./update_deployment_target.sh
```

## خطوات التشغيل

### محلياً:
```bash
cd ios
chmod +x update_deployment_target.sh
./update_deployment_target.sh
pod install
cd ..
flutter build ios --release --no-codesign
```

### على GitHub Actions:
1. اذهب إلى GitHub repository
2. اذهب إلى Actions tab
3. اختر workflow "iOS-ipa-build"
4. اضغط "Run workflow"
5. انتظر حتى يكتمل البناء

## الملفات المحدثة
- ✅ `ios/Podfile`
- ✅ `ios/Runner.xcodeproj/project.pbxproj`
- ✅ `ios/update_deployment_target.sh`
- ✅ `.github/workflows/dart.yml`

## النتيجة المتوقعة
- ✅ إزالة خطأ cloud_firestore
- ✅ بناء iOS IPA بنجاح
- ✅ رفع التطبيق على GitHub Releases

## ملاحظات مهمة
- iOS 13.0 يدعم الأجهزة من iPhone 6s وما فوق
- تأكد من اختبار التطبيق على أجهزة iOS 13+
- إذا كنت تحتاج دعم أجهزة أقدم، فكر في استخدام Firebase بديل أو إصدار أقدم 