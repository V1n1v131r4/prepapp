pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        // Repositório do Flutter
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    // Permite que plugins adicionem repositórios sem falhar o build
    repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)
    repositories {
        google()
        mavenCentral()
        // Repositório do Flutter também na resolução de dependências
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}

rootProject.name = "prepapp_3"

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}

include(":app")
