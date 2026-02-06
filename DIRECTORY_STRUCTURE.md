# TOTV+ Project Directory Structure

```
totv_plus/
│
├── android/                                    # Android native code
│   ├── app/
│   │   ├── src/
│   │   │   └── main/
│   │   │       ├── kotlin/com/totv/plus/
│   │   │       │   └── MainActivity.kt         # Main Android activity with FLAG_SECURE
│   │   │       ├── res/
│   │   │       │   ├── values/
│   │   │       │   │   ├── strings.xml        # App strings & support contact
│   │   │       │   │   ├── colors.xml         # Color resources
│   │   │       │   │   └── styles.xml         # App themes
│   │   │       │   └── xml/
│   │   │       │       └── network_security_config.xml  # SSL Pinning config
│   │   │       └── AndroidManifest.xml        # Android manifest
│   │   ├── build.gradle                       # App-level gradle config
│   │   ├── proguard-rules.pro                 # ProGuard obfuscation rules
│   │   └── google-services.json               # Firebase config (add this file)
│   ├── build.gradle                           # Project-level gradle
│   ├── settings.gradle                        # Gradle settings
│   └── gradle.properties                      # Gradle properties
│
├── ios/                                        # iOS native code
│   └── Runner/
│       ├── Info.plist                         # iOS app configuration
│       ├── AppDelegate.swift                  # iOS app delegate
│       └── GoogleService-Info.plist           # Firebase config (add this file)
│
├── lib/                                        # Flutter/Dart code
│   ├── core/
│   │   ├── config/
│   │   │   └── app_theme.dart                # App theme configuration
│   │   ├── constants/
│   │   │   └── app_constants.dart            # App-wide constants (API key, contact)
│   │   ├── services/
│   │   │   ├── video_player_service.dart     # Video playback service
│   │   │   ├── firebase_remote_config_service.dart  # Remote config
│   │   │   └── force_update_service.dart     # Force update logic
│   │   ├── utils/
│   │   │   ├── encryption_utils.dart         # Encryption utilities
│   │   │   └── ssl_pinning.dart              # SSL pinning implementation
│   │   └── widgets/
│   │       └── [common widgets]
│   │
│   ├── data/
│   │   ├── models/
│   │   │   └── content_model.dart            # Content data models
│   │   ├── repositories/
│   │   │   └── content_repository_impl.dart  # Repository implementations
│   │   └── datasources/
│   │       ├── remote_data_source.dart       # API data source
│   │       └── local_data_source.dart        # Local storage
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   └── content.dart                  # Business entities
│   │   ├── repositories/
│   │   │   └── content_repository.dart       # Repository interfaces
│   │   └── usecases/
│   │       └── get_trending_content.dart     # Business logic
│   │
│   ├── presentation/
│   │   ├── bloc/
│   │   │   └── home/
│   │   │       ├── home_bloc.dart            # BLoC logic
│   │   │       ├── home_event.dart           # BLoC events
│   │   │       └── home_state.dart           # BLoC states
│   │   ├── pages/
│   │   │   ├── home_page.dart                # Home screen
│   │   │   ├── video_player_page.dart        # Video player screen
│   │   │   └── splash_screen.dart            # Splash screen
│   │   └── widgets/
│   │       ├── player_controls.dart          # Video player controls
│   │       ├── content_carousel.dart         # Content carousel
│   │       ├── category_row.dart             # Category row widget
│   │       ├── featured_hero_banner.dart     # Featured banner
│   │       ├── bottom_nav_bar.dart           # Bottom navigation
│   │       ├── quality_selector.dart         # Quality selector
│   │       └── subtitle_selector.dart        # Subtitle selector
│   │
│   └── main.dart                              # App entry point
│
├── assets/                                     # Static assets
│   ├── config/
│   │   └── live_streams.json                 # Live streaming configuration
│   ├── images/
│   │   ├── splash_logo.png                   # Splash screen logo
│   │   └── [other images]
│   ├── icons/
│   │   ├── app_icon.png                      # App icon
│   │   └── app_icon_foreground.png           # Adaptive icon
│   └── fonts/
│       ├── Cairo-Regular.ttf                 # Arabic font
│       ├── Cairo-Bold.ttf
│       ├── Cairo-SemiBold.ttf
│       └── Cairo-Light.ttf
│
├── test/                                       # Unit & widget tests
│   └── [test files]
│
├── .gitignore                                  # Git ignore rules
├── analysis_options.yaml                      # Flutter linting rules
├── codemagic.yaml                             # Codemagic CI/CD config
├── pubspec.yaml                               # Flutter dependencies
├── README.md                                  # Project documentation
├── DEPLOYMENT_GUIDE.md                        # Deployment instructions
└── FIREBASE_SETUP.md                          # Firebase setup guide

```

## 📁 Key Files Explained

### Configuration Files

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Flutter project dependencies and assets |
| `codemagic.yaml` | CI/CD build and deployment configuration |
| `analysis_options.yaml` | Dart/Flutter code linting rules |
| `.gitignore` | Files to exclude from version control |

### Constant Files

| File | Purpose | Contains |
|------|---------|----------|
| `lib/core/constants/app_constants.dart` | App-wide constants | API Key, WhatsApp contact, CDN URLs |
| `android/.../strings.xml` | Android string resources | Support contact, app name |
| `assets/config/live_streams.json` | Live streaming config | Channel URLs, EPG data |

### Security Files

| File | Purpose |
|------|---------|
| `android/.../MainActivity.kt` | FLAG_SECURE implementation |
| `android/.../network_security_config.xml` | SSL certificate pinning |
| `android/app/proguard-rules.pro` | Code obfuscation rules |

### Firebase Files (Not in Git)

| File | Location | Source |
|------|----------|--------|
| `google-services.json` | `android/app/` | Firebase Console → Android app |
| `GoogleService-Info.plist` | `ios/Runner/` | Firebase Console → iOS app |

## 🔑 Important Notes

1. **API Keys**: Located in `lib/core/constants/app_constants.dart`
2. **Support Contact**: WhatsApp `009647714415816` in constants and strings.xml
3. **Live Streams**: Configured in `assets/config/live_streams.json`
4. **Firebase Files**: Must be downloaded from Firebase Console and placed in respective directories
5. **SSL Pinning**: Certificate fingerprints in `network_security_config.xml` need to be updated with actual values

## 📦 Build Outputs (Not in Git)

```
build/
├── app/
│   ├── outputs/
│   │   ├── apk/release/
│   │   │   └── app-release.apk
│   │   └── bundle/release/
│   │       └── app-release.aab
│   └── intermediates/
└── ios/
    └── ipa/
        └── totv_plus.ipa
```

## 🚀 Next Steps

1. Add `google-services.json` to `android/app/`
2. Add `GoogleService-Info.plist` to `ios/Runner/`
3. Update CDN URLs in `app_constants.dart` and `live_streams.json`
4. Update SSL certificate fingerprints in `network_security_config.xml`
5. Run `flutter pub get`
6. Test with `flutter run`
7. Build with `flutter build apk --release`
8. Push to GitHub
9. Configure Codemagic
10. Deploy! 🎉
