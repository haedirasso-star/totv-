# Firebase Configuration

## Setup Instructions

### Android

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your TOTV+ project
3. Navigate to Project Settings → General
4. Under "Your apps" section, find your Android app
5. Download `google-services.json`
6. Place the file in: `android/app/google-services.json`

**Package Name**: `com.totv.plus`

### iOS

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your TOTV+ project
3. Navigate to Project Settings → General
4. Under "Your apps" section, find your iOS app
5. Download `GoogleService-Info.plist`
6. Place the file in: `ios/Runner/GoogleService-Info.plist`

**Bundle ID**: `com.totv.plus`

## Remote Config

Configure the following parameters in Firebase Remote Config:

```json
{
  "app_version": "1.0.0",
  "min_supported_version": "1.0.0",
  "force_update_enabled": false,
  "enable_downloads": true,
  "enable_pip": true,
  "enable_chromecast": true,
  "enable_4k_quality": true,
  "primary_color": "#FF6B00",
  "show_ads": false,
  "max_simultaneous_streams": 2,
  "maintenance_mode": false
}
```

## Firebase Services Used

- ✅ Authentication
- ✅ Firestore Database
- ✅ Remote Config
- ✅ Analytics
- ✅ Crashlytics
- ✅ Cloud Messaging

## Security Rules

### Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /content/{contentId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin can write
    }
    
    match /watch_history/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Note

**DO NOT** commit `google-services.json` or `GoogleService-Info.plist` to Git!

These files contain sensitive information and are already in `.gitignore`.
