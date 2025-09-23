import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

/**
 * Bloqueios de dependências não-FLOSS neste módulo.
 * Usamos configureEach (Kotlin DSL) para atingir TODAS as configurações (compile/runtime, debug/release).
 */
configurations.configureEach {
    // GMS/Firebase
    exclude(group = "com.google.android.gms")
    exclude(group = "com.google.android.gms", module = "play-services-location")
    exclude(group = "com.google.android.gms", module = "play-services-basement")
    exclude(group = "com.google.android.gms", module = "play-services-tasks")
    exclude(group = "com.google.firebase")

    // Play Core (que trouxe as classes com.google.android.play.core.* no APK)
    exclude(group = "com.google.android.play")
    exclude(group = "com.google.android.play", module = "core")
    exclude(group = "com.google.android.play", module = "core-common")

    // Cinto de segurança: se alguma cadeia tentar reintroduzir Play Core, falha o build.
    resolutionStrategy.eachDependency {
        if (requested.group == "com.google.android.play") {
            throw GradleException("Dependência proibida detectada: ${requested.group}:${requested.name}:${requested.version}")
        }
    }
}

// Lê versionName/versionCode do local.properties (preenchido pelo Flutter/F-Droid)
val localProps = Properties().apply {
    val f = rootProject.file("local.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
val flutterVersionName = (localProps.getProperty("flutter.versionName") ?: "1.0.0").trim()
val flutterVersionCode = (localProps.getProperty("flutter.versionCode") ?: "1").trim()

android {
    namespace = "com.bunqr.prepapp.fdroid"

    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.bunqr.prepapp.fdroid"
        minSdk = 21
        targetSdk = 35

        // Usa as versões vindas do local.properties (ou fallback)
        versionName = flutterVersionName
        versionCode = flutterVersionCode.toInt()
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }

    buildFeatures { buildConfig = true }

    buildTypes {
        getByName("release") {
            // Remove classes “penduradas”
            isMinifyEnabled = true
            isShrinkResources = true
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
