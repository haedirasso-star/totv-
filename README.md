# ToTV+ - تطبيق البث المباشر والأفلام

تطبيق ToTV+ هو تطبيق بث مباشر وأفلام مبني بـ Flutter باستخدام Clean Architecture.

## المميزات الرئيسية

### 1. البث المباشر (Live TV)
- دعم قنوات M3U مع HTTP Referrer
- قنوات عراقية ولبنانية وعربية
- جودات متعددة (1080p, 720p, 480p)
- بث مباشر للرياضة والأخبار

### 2. الأفلام (VOD)
- قاعدة بيانات ضخمة من TMDB API
- بحث ذكي في الأفلام
- تصنيف حسب النوع
- معلومات تفصيلية عن الأفلام

### 3. التحديث عن بعد (Remote Config)
- تحديث قائمة القنوات دون إعادة رفع التطبيق
- تحديث مفتاح API الأفلام
- إعدادات التطبيق القابلة للتحديث

### 4. واجهة مستخدم احترافية
- تصميم مشابه لتطبيق TOD
- دعم العربية بالكامل
- رسوم متحركة سلسة
- واجهة سهلة الاستخدام

## البنية المعمارية

```
lib/
├── core/
│   ├── error/          # معالجة الأخطاء
│   ├── network/        # إعدادات الشبكة
│   └── services/       # الخدمات المشتركة
├── data/
│   ├── datasources/    # مصادر البيانات
│   ├── models/         # نماذج البيانات
│   └── repositories/   # تطبيق المستودعات
├── domain/
│   ├── entities/       # الكيانات
│   ├── repositories/   # واجهات المستودعات
│   └── usecases/       # حالات الاستخدام
├── presentation/
│   ├── bloc/          # إدارة الحالة
│   ├── pages/         # الصفحات
│   └── widgets/       # المكونات
└── injection/         # حقن الاعتماديات
```

## التثبيت والتشغيل

### المتطلبات
- Flutter SDK 3.2.0 أو أحدث
- Android Studio / VS Code
- Java 17
- Firebase Project

### خطوات التثبيت

1. **استنساخ المشروع**
```bash
git clone <repository-url>
cd totv_plus
```

2. **تثبيت المكتبات**
```bash
flutter pub get
```

3. **إعداد Firebase**
- الملف `google-services.json` موجود بالفعل في `android/app/`
- تأكد من إضافة SHA-1 fingerprint في Firebase Console

4. **تشغيل التطبيق**
```bash
flutter run
```

## Firebase Remote Config

### المفاتيح المتاحة

#### 1. `live_channels_m3u` (String)
قائمة القنوات بصيغة M3U. مثال:
```
#EXTM3U
#EXTINF:-1 tvg-id="test" http-referrer="https://example.com",Test Channel
#EXTVLCOPT:http-referrer=https://example.com
https://stream.example.com/playlist.m3u8
```

#### 2. `movie_api_key` (String)
مفتاح TMDB API. القيمة الافتراضية:
```
5b166a24c91f59178e8ce30f1f3735c0
```

#### 3. `app_settings` (JSON)
إعدادات التطبيق:
```json
{
  "enable_ads": false,
  "enable_analytics": true,
  "min_app_version": "1.0.0"
}
```

### كيفية التحديث

1. افتح Firebase Console
2. اذهب إلى Remote Config
3. أضف/عدل المفاتيح المذكورة أعلاه
4. انشر التغييرات
5. التطبيق سيحمل التغييرات تلقائياً

## الملفات الرئيسية

### 1. `lib/domain/entities/content.dart`
```dart
// كيان المحتوى مع جميع الحقول المطلوبة
class Content {
  final String id;
  final String title;
  final bool isLive;
  final List<StreamingUrl> streamingUrls;
  final List<QualityOption> qualityOptions;
  // ... المزيد من الحقول
}
```

### 2. `lib/data/repositories/content_repository_impl.dart`
```dart
// تطبيق المستودع مع القنوات المدمجة
class ContentRepositoryImpl {
  static const String _defaultM3U = '''
    // قائمة القنوات المدمجة
  ''';
}
```

### 3. `lib/core/services/video_player_service.dart`
```dart
// خدمة المشغل مع دعم HTTP Referrer
class VideoPlayerService {
  Map<String, String> _buildHeaders(StreamingUrl streamUrl) {
    // بناء الـ Headers مع Referrer
  }
}
```

### 4. `lib/presentation/pages/home_page.dart`
```dart
// الصفحة الرئيسية بواجهة مشابهة لـ TOD
class HomePage extends StatefulWidget {
  // التبويبات والمحتوى
}
```

## حل المشاكل الشائعة

### المشكلة: `InvalidType in BlocBuilder`
**الحل**: تم إصلاح الأنواع في جميع الـ BlocBuilders

### المشكلة: البث لا يعمل مع بعض القنوات
**الحل**: تأكد من إضافة `http-referrer` في ملف M3U:
```
#EXTVLCOPT:http-referrer=https://example.com
```

### المشكلة: الأفلام لا تظهر
**الحل**: تأكد من صحة مفتاح TMDB API في Remote Config

## البناء للإنتاج

```bash
# بناء APK
flutter build apk --release

# بناء App Bundle
flutter build appbundle --release
```

الملفات ستكون في:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

## الترخيص

هذا المشروع للاستخدام الشخصي فقط.

## الدعم

للمساعدة أو الإبلاغ عن المشاكل، يرجى فتح Issue في المستودع.
