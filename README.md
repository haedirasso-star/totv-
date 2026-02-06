# TOTV+ - Premium Streaming Platform

<div align="center">
  <img src="assets/icons/app_icon.png" alt="TOTV+ Logo" width="200"/>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg)](https://flutter.dev/)
  [![License](https://img.shields.io/badge/License-Proprietary-red.svg)]()
  [![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-green.svg)]()
</div>

## 📱 About TOTV+

TOTV+ is a premium streaming platform designed for the Middle East market, offering:

- **Live Sports** - Premier League, Champions League, and more
- **Movies & Series** - Thousands of Arabic and international content
- **Live TV** - News, entertainment, and kids channels
- **4K Quality** - Ultra HD streaming with adaptive bitrate
- **Multi-device** - Watch on phone, tablet, and TV

## ✨ Features

### Core Features
- 🎬 **Video on Demand** - Extensive library of movies and series
- 📡 **Live Streaming** - Real-time sports and TV channels
- 🔄 **Adaptive Bitrate** - Automatic quality adjustment (240p to 4K)
- 💾 **Offline Downloads** - Watch content offline
- 🖼️ **Picture-in-Picture** - Multitask while watching
- 📱 **Chromecast Support** - Stream to your TV

### Security Features
- 🔒 **DRM Protection** - Widevine L1 encryption
- 🛡️ **SSL Pinning** - Secure API communications
- 🚫 **Screen Recording Prevention** - FLAG_SECURE on Android
- 🔐 **End-to-End Encryption** - Content protection
- 👤 **Multi-profile Support** - Family-friendly accounts

### UI/UX
- 🌙 **Dark Mode** - Eye-friendly interface
- 🌍 **RTL Support** - Full Arabic language support
- ⚡ **Fast Loading** - Optimized caching
- 🎨 **Beautiful Design** - Modern, intuitive interface

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **BLoC** state management:

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── constants/       # App-wide constants
│   ├── services/        # Core services
│   └── utils/           # Utility functions
├── data/
│   ├── models/          # Data models
│   ├── repositories/    # Repository implementations
│   └── datasources/     # Remote & Local data sources
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business logic
└── presentation/
    ├── bloc/            # BLoC state management
    ├── pages/           # App screens
    └── widgets/         # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites

```bash
Flutter SDK: >=3.19.0
Dart SDK: >=3.3.0
Android Studio / Xcode
Firebase Account
```

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/totv_plus.git
cd totv_plus
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Setup Firebase**
   
   - Download `google-services.json` and place in `android/app/`
   - Download `GoogleService-Info.plist` and place in `ios/Runner/`

4. **Run the app**
```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

## 🔧 Configuration

### API Keys

The Movie Database (TMDB) API key is stored in `lib/core/constants/app_constants.dart`:

```dart
static const String movieApiKey = '5b166a24c91f59178e8ce30f1f3735c0';
```

### Support Contact

WhatsApp/Phone: `009647714415816`

Configured in:
- `lib/core/constants/app_constants.dart`
- `android/app/src/main/res/values/strings.xml`

### Live Streaming

Live stream URLs are configured in `assets/config/live_streams.json`:

```json
{
  "live_channels": [
    {
      "id": "sport_1",
      "name": "TOTV Sport 1",
      "streaming_urls": [...]
    }
  ]
}
```

## 📦 Build & Deploy

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build iOS
flutter build ios --release

# Build IPA
flutter build ipa --release
```

### Codemagic CI/CD

This project includes `codemagic.yaml` for automated builds:

- **Workflow 1**: Android Debug/Release builds
- **Workflow 2**: iOS Debug/Release builds
- **Workflow 3**: Automated Play Store deployment
- **Workflow 4**: Automated App Store deployment

**Environment Variables Required:**
- `MOVIE_API_KEY`
- `GOOGLE_SERVICES_JSON`
- `GOOGLE_SERVICE_INFO_PLIST`
- `CM_KEYSTORE_PATH`
- `CM_KEYSTORE_PASSWORD`
- `CM_KEY_ALIAS`
- `CM_KEY_PASSWORD`

## 🔐 Security

### Android Security
- **FLAG_SECURE** - Prevents screenshots and screen recording
- **SSL Pinning** - Certificate pinning for CDN servers
- **ProGuard** - Code obfuscation in release builds
- **Root Detection** - Detects rooted devices

### iOS Security
- **Jailbreak Detection** - Detects jailbroken devices
- **SSL Pinning** - Certificate validation
- **Code Obfuscation** - Symbol stripping

### DRM Configuration
```json
{
  "widevine_license_url": "https://drm.totv.plus/widevine/license",
  "fairplay_certificate_url": "https://drm.totv.plus/fairplay/cert"
}
```

## 📱 Screenshots

<!-- Add screenshots here -->

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📄 License

Copyright © 2025 TOTV+. All rights reserved.

This is proprietary software. Unauthorized copying, distribution, or use is strictly prohibited.

## 👥 Contact & Support

- **WhatsApp**: +964 771 441 5816
- **Email**: support@totv.plus
- **Website**: https://totv.plus

## 🙏 Acknowledgments

- Flutter Team
- Firebase Team
- The Movie Database (TMDB)
- All open-source contributors

---

**Made with ❤️ in Iraq**
