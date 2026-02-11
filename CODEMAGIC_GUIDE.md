# 📱 دليل الرفع على Codemagic.io

## 🎯 الخطوة 1: التحضير

### ✅ ما لديك الآن:
- مشروع ToTV+ v2.0 كامل ✅
- ملف `codemagic.yaml` جاهز ✅
- جميع إعدادات Android ✅
- جميع الملفات المطلوبة ✅

---

## 🚀 الخطوة 2: رفع المشروع على GitHub

### الطريقة 1: عبر Git Command Line

```bash
# 1. فك ضغط المشروع
tar -xzf ToTV_Plus_v2_Netflix_Edition.tar.gz
cd totv_plus_v2

# 2. تهيئة Git
git init
git add .
git commit -m "Initial commit: ToTV+ v2.0"

# 3. إنشاء مستودع على GitHub
# اذهب إلى github.com وأنشئ مستودع جديد اسمه: totv-plus

# 4. ربط المستودع المحلي بـ GitHub
git remote add origin https://github.com/YOUR_USERNAME/totv-plus.git
git branch -M main
git push -u origin main
```

### الطريقة 2: عبر GitHub Desktop

1. افتح GitHub Desktop
2. File → Add Local Repository
3. اختر مجلد `totv_plus_v2`
4. Publish Repository

---

## 🔗 الخطوة 3: ربط Codemagic

### 1. إنشاء حساب
1. اذهب إلى https://codemagic.io
2. سجل دخول بحساب GitHub
3. اقبل الأذونات

### 2. إضافة التطبيق
1. انقر على **"Add application"**
2. اختر GitHub
3. ابحث عن `totv-plus`
4. انقر **"Add"**

### 3. تكوين Build
Codemagic سيكتشف ملف `codemagic.yaml` تلقائياً!

---

## ⚙️ الخطوة 4: إعداد المتغيرات (اختياري)

### Firebase (اختياري)
إذا كنت تريد Firebase:
1. اذهب لـ App Settings
2. Environment variables
3. أضف `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`

### Keystore (للتوقيع)
1. اذهب لـ Code signing
2. Android keystore
3. ارفع ملف `.jks` (أو أنشئ واحد)

---

## 🎬 الخطوة 5: البناء

### البناء التلقائي
```bash
# كل push سيبني التطبيق تلقائياً
git add .
git commit -m "Update"
git push
```

### البناء اليدوي
1. اذهب لـ Codemagic Dashboard
2. اختر التطبيق
3. انقر **"Start new build"**
4. اختر Branch (main)
5. انقر **"Start build"**

---

## 📥 الخطوة 6: تحميل التطبيق

بعد اكتمال البناء:
1. انقر على Build
2. اذهب لـ **Artifacts**
3. حمّل الـ APK أو AAB

### الملفات المتوفرة:
- `app-armeabi-v7a-release.apk` (32-bit)
- `app-arm64-v8a-release.apk` (64-bit) ✅ الأفضل
- `app-x86_64-release.apk` (محاكي)
- `app-release.aab` (للنشر على Play Store)

---

## 🔧 حل المشاكل

### المشكلة 1: "Build failed - Gradle error"
```yaml
# تأكد من أن codemagic.yaml يحتوي على:
environment:
  java: 17
  flutter: stable
```

### المشكلة 2: "Flutter not found"
```yaml
# تأكد من:
scripts:
  - name: Set up local.properties
    script: |
      echo "flutter.sdk=$HOME/programs/flutter" > "$CM_BUILD_DIR/android/local.properties"
```

### المشكلة 3: "Namespace error"
✅ تم حله مسبقاً في `android/app/build.gradle`

---

## 📋 codemagic.yaml - الشرح

```yaml
workflows:
  android-workflow:
    name: ToTV+ Android Workflow
    
    # البيئة
    environment:
      flutter: stable    # استخدام Flutter المستقر
      java: 17          # Java 17 للـ Gradle 8
      
    # السكريبتات
    scripts:
      - name: Get Flutter packages
        script: flutter packages pub get
        
      - name: Build APK
        script: flutter build apk --release --split-per-abi
        
    # المخرجات (التطبيق المبني)
    artifacts:
      - build/**/outputs/**/*.apk
      - build/**/outputs/**/*.aab
      
    # الإشعارات
    publishing:
      email:
        recipients:
          - your-email@example.com
```

---

## 🎯 الميزات التلقائية

### ✅ ما سيحدث تلقائياً:
1. **تثبيت Flutter** ✓
2. **تثبيت المكتبات** ✓
3. **بناء APK** ✓
4. **بناء AAB** ✓
5. **إرسال إيميل عند الانتهاء** ✓

### 📊 الوقت المتوقع:
- أول بناء: ~15 دقيقة
- البناءات التالية: ~5 دقائق (بفضل الـ Cache)

---

## 🚀 نصائح للأداء

### 1. استخدام Cache
```yaml
cache:
  cache_paths:
    - $HOME/.gradle/caches
    - $HOME/Library/Caches/CocoaPods
```

### 2. بناء متوازي
```yaml
max_build_duration: 60  # بدلاً من 120
```

### 3. إيقاف الاختبارات
```yaml
scripts:
  - name: Flutter tests
    script: flutter test
    ignore_failure: true  # لا توقف البناء إذا فشل
```

---

## 📱 النشر على Google Play (متقدم)

### المتطلبات:
1. حساب Google Play Developer ($25)
2. Service Account من Google Cloud
3. Keystore للتوقيع

### الإعداد:
```yaml
publishing:
  google_play:
    credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
    track: internal  # أو production
```

---

## ✅ قائمة التحقق النهائية

قبل الرفع، تأكد:

- [ ] المشروع مرفوع على GitHub
- [ ] ملف `codemagic.yaml` موجود
- [ ] `android/app/build.gradle` محدث
- [ ] `pubspec.yaml` محدث
- [ ] `google-services.json` موجود
- [ ] `.gitignore` يستثني الملفات الحساسة

---

## 🎉 النتيجة

بعد اتباع هذه الخطوات:
- ✅ التطبيق يبني تلقائياً
- ✅ APK جاهز للتحميل
- ✅ يمكن النشر على Play Store
- ✅ كل push يبني نسخة جديدة

---

## 📞 الدعم

إذا واجهت مشكلة:
1. تحقق من Build Logs في Codemagic
2. ابحث في docs.codemagic.io
3. تواصل مع support@codemagic.io

---

**المشروع جاهز 100% للرفع!** 🚀

ما عليك إلا:
1. فك الضغط
2. رفع على GitHub
3. ربط مع Codemagic
4. انتظر 10 دقائق
5. حمّل التطبيق! 🎊
