plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bunqr.prepapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.bunqr.prepapp"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = 5
        versionName = "1.0.5"
    }

    signingConfigs {
        create("release") {
            storeFile = file("../../prepapp.keystore") // Caminho para o keystore
            storePassword = System.getenv("KEYSTORE_PASSWORD") ?: "B3nj4m1n"
            keyAlias = "prepapp"
            keyPassword = System.getenv("KEY_PASSWORD") ?: "B3nj4m1n"
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
