plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bunqr.prepapp.fdroid"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // (Opcional) Se futuramente quiser usar BuildConfig.*:
    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        applicationId = "com.bunqr.prepapp.fdroid"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = 1_000_001
        versionName = "1.0.1-fdroid"
        // REMOVIDO: buildConfigField("boolean", "FDROID", "true")
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // F-Droid re-assina; deixe sem assinatura local
            signingConfig = null
        }
        getByName("debug") {
            // padrão
        }
    }
}

flutter {
    source = "../.."
}
