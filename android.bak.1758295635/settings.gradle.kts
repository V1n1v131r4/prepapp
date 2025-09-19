// android/settings.gradle.kts

pluginManagement {
    // Lê flutter.sdk do env ou do local.properties
    val props = java.util.Properties().apply {
        val f = java.io.File(rootDir, "local.properties")
        if (f.exists()) f.inputStream().use { load(it) }
    }
    val flutterSdkPath = System.getenv("FLUTTER_HOME")
        ?: System.getenv("FLUTTER_SDK")
        ?: props.getProperty("flutter.sdk")
        ?: throw GradleException(
            "Flutter SDK não encontrado. Defina flutter.sdk em android/local.properties " +
            "ou FLUTTER_HOME/FLUTTER_SDK."
        )

    // Plugin Gradle do Flutter
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        // Ordem importa: google() primeiro para AGP
        google()
        mavenCentral()
        gradlePluginPortal()
        maven(url = "https://storage.googleapis.com/download.flutter.io")
    }
}

// Loader do plugin do Flutter
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
}

// Repositórios globais (sem repositoriesMode para não gerar avisos)
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven(url = "https://storage.googleapis.com/download.flutter.io")
    }
}

rootProject.name = "android"
include(":app")
