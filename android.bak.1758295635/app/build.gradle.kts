// android/app/build.gradle.kts

plugins {
    id("com.android.application")     // classpath vem do buildscript (raiz)
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bunqr.prepapp.fdroid"

    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.bunqr.prepapp.fdroid"
        minSdk = 21
        targetSdk = 35
        versionCode = 1000005
        versionName = "1.0.5-fdroid"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }

    buildFeatures { buildConfig = true }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // sem signingConfig — F-Droid re-assina
        }
    }
}

flutter {
    source = "../.."
}
