plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bunqr.prepapp.fdroid"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions { jvmTarget = "17" }   

    // Habilite se for usar BuildConfig.* agora ou no futuro
    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        applicationId = "com.bunqr.prepapp.fdroid"
        minSdk = 21
        targetSdk = 35
        versionCode = 1000005
        versionName = "1.0.5-fdroid"
        // Sem buildConfigField para manter o schema limpo no F-Droid
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Não defina signing aqui — o F-Droid re-assina
        }
        getByName("debug") {
            // padrão
        }
    }
}

flutter {
    source = "../.."
}
