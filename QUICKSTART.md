# 🚀 TOTV+ Quick Start Guide

## ⚡ 5-Minute Setup

### Step 1: Clone & Install (2 minutes)

```bash
# Clone repository
git clone https://github.com/yourusername/totv_plus.git
cd totv_plus

# Generate iOS project (IMPORTANT for iOS builds)
flutter create --org com.totv --platforms=ios .

# Install dependencies
flutter pub get
```

### Step 2: Firebase Setup (2 minutes)

**Android:**
1. Download `google-services.json` from Firebase Console
2. Place in: `android/app/google-services.json`

**iOS:**
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place in: `ios/Runner/GoogleService-Info.plist`

### Step 3: Run the App (1 minute)

```bash
# Connect your device/emulator and run
flutter run
```

That's it! Your app should now be running. 🎉

---

## 📋 Configuration Checklist

All configurations are already done! Just verify:

✅ **API Key**: TMDB API configured in `lib/core/constants/app_constants.dart`
- Value: `5b166a24c91f59178e8ce30f1f3735c0`

✅ **Support Contact**: WhatsApp configured
- Number: `009647714415816`
- Location: `app_constants.dart` and `strings.xml`

✅ **Live Streams**: Configuration file ready
- File: `assets/config/live_streams.json`
- Update CDN URLs when ready

✅ **Security**: FLAG_SECURE enabled
- File: `android/.../MainActivity.kt`
- Prevents screenshots and screen recording

✅ **CI/CD**: Codemagic configuration ready
- File: `codemagic.yaml`
- Just connect to your repository

---

## 🔧 Before First Build

### Update These Values

**1. CDN URLs** (in `lib/core/constants/app_constants.dart`):
```dart
static const List<String> cdnBaseUrls = [
  'https://cdn1.totv.plus',  // Replace with your actual CDN
  'https://cdn2.totv.plus',
  'https://cdn3.totv.plus',
];
```

**2. Live Stream URLs** (in `assets/config/live_streams.json`):
```json
{
  "streaming_urls": [
    {
      "url": "https://your-actual-stream-url.m3u8"  // Update this
    }
  ]
}
```

**3. SSL Certificate Fingerprints** (in `android/.../network_security_config.xml`):
```xml
<pin digest="SHA-256">YOUR_ACTUAL_SHA256_FINGERPRINT</pin>
```

---

## 📱 Building for Release

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
flutter build ios --release
# Then use Xcode to archive and upload
```

---

## 🐛 Common Issues & Fixes

### Issue 1: "google-services.json not found"
**Fix:** Download from Firebase Console and place in `android/app/`

### Issue 2: "Flutter SDK not found"
**Fix:** 
```bash
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

### Issue 3: "Gradle build failed"
**Fix:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Issue 4: "iOS build failed"
**Fix:**
```bash
cd ios
pod install
cd ..
flutter clean
flutter build ios
```

---

## 📚 Documentation

- **Full Guide**: See `IMPLEMENTATION_GUIDE.md`
- **Deployment**: See `DEPLOYMENT_GUIDE.md`
- **Firebase Setup**: See `FIREBASE_SETUP.md`
- **Directory Structure**: See `DIRECTORY_STRUCTURE.md`

---

## 🎯 Next Steps

1. ✅ App is running locally
2. ⬜ Update CDN URLs with your actual streaming servers
3. ⬜ Add your Firebase configuration files
4. ⬜ Test video playback with real streams
5. ⬜ Configure Codemagic for automated builds
6. ⬜ Submit to app stores

---

## 💬 Need Help?

- **WhatsApp**: +964 771 441 5816
- **Email**: support@totv.plus
- **Documentation**: Check the guides in the project root

---

## ✨ Features Already Implemented

✅ Video streaming with HLS support
✅ Live TV channels
✅ Picture-in-Picture mode
✅ Multiple quality options (240p to 4K)
✅ Arabic & English support (RTL)
✅ Firebase integration
✅ Screen recording prevention (Android)
✅ SSL pinning
✅ Beautiful UI/UX
✅ BLoC state management
✅ Clean architecture
✅ CI/CD ready

---

**Happy Coding! 🚀**
