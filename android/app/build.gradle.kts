plugins {
    id("com.android.application")
    id("kotlin-android")
    // تفعيل خدمات جوجل لربط Firebase
    id("com.google.gms.google-services") 
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // تم التعديل ليتطابق مع ملف google-services.json
    namespace = "com.totv.plus" 
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // تم التعديل ليكون معرف التطبيق احترافي ومتوافق مع Firebase
        applicationId = "com.totv.plus" 
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // سنستخدم debug keys حالياً للبناء السريع في Codemagic
            signingConfig = signingConfigs.getByName("debug")
            
            // تحسينات إضافية لنسخة الـ Release للربح (تصغير الحجم)
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
