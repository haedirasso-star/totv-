# TOTV+ Deployment Guide

## 📋 Pre-Deployment Checklist

### 1. Firebase Setup ✅
- [ ] Create Firebase project
- [ ] Add Android app (com.totv.plus)
- [ ] Add iOS app (com.totv.plus)
- [ ] Download `google-services.json`
- [ ] Download `GoogleService-Info.plist`
- [ ] Enable Authentication
- [ ] Enable Firestore
- [ ] Enable Remote Config
- [ ] Enable Analytics
- [ ] Enable Crashlytics
- [ ] Enable Cloud Messaging

### 2. API Keys & Secrets ✅
- [ ] TMDB API Key: `5b166a24c91f59178e8ce30f1f3735c0`
- [ ] Firebase API Keys (in downloaded files)
- [ ] DRM License URLs (if applicable)
- [ ] CDN URLs (replace placeholders)

### 3. Code Configuration ✅
- [ ] Update `lib/core/constants/app_constants.dart`
- [ ] Update `assets/config/live_streams.json`
- [ ] Verify WhatsApp contact: `009647714415816`
- [ ] Update CDN URLs in constants

### 4. Security ✅
- [ ] SSL Certificate Pinning configured
- [ ] FLAG_SECURE enabled (Android)
- [ ] ProGuard rules configured
- [ ] Code obfuscation enabled
- [ ] Root/Jailbreak detection implemented

---

## 🔧 Local Development Setup

### Step 1: Install Dependencies

```bash
flutter pub get
```

### Step 2: Setup Firebase Files

```bash
# Android
# Place google-services.json in android/app/

# iOS
# Place GoogleService-Info.plist in ios/Runner/
```

### Step 3: Run App

```bash
# Debug mode
flutter run

# Release mode (Android)
flutter run --release

# Release mode (iOS)
flutter run --release -d ios
```

---

## 🏗️ Building for Production

### Android APK

```bash
flutter build apk --release \
  --dart-define=MOVIE_API_KEY=5b166a24c91f59178e8ce30f1f3735c0 \
  --obfuscate \
  --split-debug-info=/symbols
```

### Android App Bundle (AAB)

```bash
flutter build appbundle --release \
  --dart-define=MOVIE_API_KEY=5b166a24c91f59178e8ce30f1f3735c0 \
  --obfuscate \
  --split-debug-info=/symbols
```

### iOS IPA

```bash
flutter build ipa --release \
  --dart-define=MOVIE_API_KEY=5b166a24c91f59178e8ce30f1f3735c0 \
  --obfuscate \
  --split-debug-info=/symbols
```

---

## 🚀 Codemagic CI/CD Setup

### Step 1: Connect Repository

1. Go to [Codemagic](https://codemagic.io)
2. Sign in with GitHub/GitLab/Bitbucket
3. Add your TOTV+ repository

### Step 2: Configure Environment Variables

In Codemagic dashboard, add these environment variables:

**Secure Variables:**
```
MOVIE_API_KEY = 5b166a24c91f59178e8ce30f1f3735c0
GOOGLE_SERVICES_JSON = <base64_encoded_google-services.json>
GOOGLE_SERVICE_INFO_PLIST = <base64_encoded_GoogleService-Info.plist>
```

**Android Signing:**
```
CM_KEYSTORE_PATH = <path_to_keystore>
CM_KEYSTORE_PASSWORD = <your_keystore_password>
CM_KEY_ALIAS = <your_key_alias>
CM_KEY_PASSWORD = <your_key_password>
```

**iOS Signing:**
- Configure App Store Connect integration
- Add provisioning profiles
- Add certificates

### Step 3: Encode Firebase Files

```bash
# Encode google-services.json
base64 -i android/app/google-services.json -o google-services-base64.txt

# Encode GoogleService-Info.plist
base64 -i ios/Runner/GoogleService-Info.plist -o google-service-info-base64.txt
```

Copy the contents and paste into Codemagic environment variables.

### Step 4: Configure Workflows

The `codemagic.yaml` file is already configured with 4 workflows:

1. **android-workflow** - Debug/Internal testing builds
2. **ios-workflow** - Debug/TestFlight builds
3. **android-release-workflow** - Production Play Store deployment
4. **ios-release-workflow** - Production App Store deployment

### Step 5: Trigger Build

**Manual Build:**
- Go to Codemagic dashboard
- Select workflow
- Click "Start new build"

**Automatic Build (on Git tag):**
```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## 📱 Google Play Store Deployment

### Step 1: Create App on Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app: "TOTV+"
3. Fill in app details
4. Set up content rating
5. Add app category
6. Complete privacy policy

### Step 2: Create Service Account

1. Go to Google Cloud Console
2. Create service account
3. Download JSON key
4. Add to Play Console (Settings → API access)

### Step 3: Upload AAB

**Manual Upload:**
- Build → Upload AAB to Internal Testing
- Complete release details
- Submit for review

**Automated (Codemagic):**
- Configure `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` in Codemagic
- Push git tag
- Automatic deployment to Play Store

### Step 4: Staged Rollout

Start with:
- Internal testing (100 users)
- Closed testing (1,000 users)
- Open testing (10,000 users)
- Production (10% → 50% → 100%)

---

## 🍎 Apple App Store Deployment

### Step 1: Create App on App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app
3. Bundle ID: `com.totv.plus`
4. App name: "TOTV+"
5. Primary language: Arabic
6. Category: Entertainment

### Step 2: Configure App Information

- App subtitle
- Description (Arabic & English)
- Keywords
- Screenshots (6.5", 5.5", iPad Pro)
- App icon (1024x1024)
- Privacy policy URL

### Step 3: Upload Build

**Manual Upload:**
```bash
flutter build ipa --release
# Use Xcode Organizer to upload
```

**Automated (Codemagic):**
- Configure App Store Connect integration
- Push git tag
- Automatic TestFlight deployment

### Step 4: Submit for Review

- Complete App Review Information
- Add demo account credentials
- Submit for review
- Wait 1-3 days for approval

---

## 🔄 Version Management

### Version Naming Convention

```
MAJOR.MINOR.PATCH+BUILD_NUMBER

Example: 1.0.0+1
- MAJOR: Breaking changes
- MINOR: New features
- PATCH: Bug fixes
- BUILD_NUMBER: Incremental build counter
```

### Updating Version

**In pubspec.yaml:**
```yaml
version: 1.0.0+1
```

**Command line:**
```bash
flutter build apk --build-name=1.0.1 --build-number=2
```

---

## 🐛 Troubleshooting

### Common Issues

**1. Missing google-services.json**
```
Error: File google-services.json is missing
Solution: Download from Firebase Console and place in android/app/
```

**2. Gradle build failed**
```
Error: Could not resolve all artifacts
Solution: Update gradle version in android/build.gradle
```

**3. iOS build failed**
```
Error: Provisioning profile doesn't match
Solution: Update signing in Xcode or Codemagic
```

**4. Flutter version mismatch**
```
Error: Flutter SDK version mismatch
Solution: Run `flutter upgrade` and `flutter pub get`
```

---

## 📊 Monitoring & Analytics

### Firebase Crashlytics

Monitor crashes in Firebase Console:
- Crash-free users percentage
- Most common crashes
- Affected devices
- Stack traces

### Firebase Analytics

Track user behavior:
- Active users (daily/weekly/monthly)
- Screen views
- User retention
- Custom events

### Performance Monitoring

Monitor app performance:
- App startup time
- Screen rendering
- Network requests
- Custom traces

---

## 🔐 Security Best Practices

### Before Release

- [ ] Remove all debug logs
- [ ] Verify SSL pinning
- [ ] Test root/jailbreak detection
- [ ] Verify DRM implementation
- [ ] Test offline functionality
- [ ] Verify payment security (if applicable)

### App Store Guidelines

- [ ] No pirated content
- [ ] Proper content rating
- [ ] Privacy policy required
- [ ] Terms of service
- [ ] GDPR compliance (if EU users)

---

## 📞 Support

For deployment issues, contact:

- **Technical Lead**: dev@totv.plus
- **WhatsApp**: +964 771 441 5816
- **Emergency**: Use Codemagic support chat

---

## ✅ Final Checklist Before Going Live

- [ ] All Firebase services configured
- [ ] API keys properly secured
- [ ] SSL certificates valid
- [ ] Content properly licensed
- [ ] Payment system tested (if applicable)
- [ ] Privacy policy published
- [ ] Terms of service published
- [ ] Support channels active
- [ ] App store listings complete
- [ ] Screenshots and videos uploaded
- [ ] Beta testing completed
- [ ] Performance tested on multiple devices
- [ ] Security audit completed
- [ ] Backup systems in place
- [ ] Monitoring/alerting configured
- [ ] Customer support trained

---

**Good luck with your deployment! 🚀**
