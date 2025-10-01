import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter plugin deve vir depois
    id("dev.flutter.flutter-gradle-plugin")
}

// Lê versionName/versionCode do local.properties (preenchido pelo Flutter)
val localProps = Properties().apply {
    val f = rootProject.file("local.properties") // rootProject = pasta android/
    if (f.exists()) f.inputStream().use { load(it) }
}
val flutterVersionName = (localProps.getProperty("flutter.versionName") ?: "1.0.0").trim()
val flutterVersionCode = (localProps.getProperty("flutter.versionCode") ?: "1").trim()

android {
    // Namespace base (alinhar com package)
    namespace = "com.bunqr.prepapp"

    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.bunqr.prepapp"
        minSdk = 21
        targetSdk = 35

        versionName = flutterVersionName
        versionCode = flutterVersionCode.toInt()
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }

    buildFeatures { buildConfig = true }

    // —— ASSINATURA: valida key.properties e aplica no release ——
    signingConfigs {
        create("release") {
            val propsFile = rootProject.file("key.properties")
            if (!propsFile.exists()) {
                throw GradleException("Arquivo key.properties não encontrado em: ${propsFile.path}. Crie-o com storeFile/storePassword/keyAlias/keyPassword.")
            }
            val props = Properties().apply { propsFile.inputStream().use { load(it) } }

            fun need(name: String): String =
                props.getProperty(name)?.trim()?.takeIf { it.isNotEmpty() }
                    ?: throw GradleException("Config de assinatura ausente: '$name' em ${propsFile.path}")

            val relPath = need("storeFile")
            val absFile = rootProject.projectDir.toPath().resolve(relPath).normalize().toFile()
            if (!absFile.exists()) {
                throw GradleException("Keystore não encontrado em: ${absFile.path} (ajuste storeFile em ${propsFile.path})")
            }

            val st = props.getProperty("storeType")?.trim()?.lowercase()
            if (!st.isNullOrEmpty()) {
                storeType = when (st) {
                    "pkcs12", "p12" -> "pkcs12"
                    "jks" -> "jks"
                    else -> throw GradleException("storeType inválido em ${propsFile.path}: '$st' (use 'pkcs12' ou 'jks').")
                }
            }

            storeFile = absFile
            storePassword = need("storePassword")
            keyAlias = need("keyAlias")
            keyPassword = need("keyPassword")

            enableV1Signing = true
            enableV2Signing = true
            enableV3Signing = true
            enableV4Signing = true
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("debug") {
            // nada especial
        }
    }

    // — Diagnóstico opcional: loga o que está sendo usado no release —
    afterEvaluate {
        applicationVariants.all {
            if (name == "release") {
                println(
                    ">>> DIAG release signing: storeFile=${signingConfig?.storeFile} " +
                        "keyAlias=${signingConfig?.keyAlias} " +
                        "hasStorePwd=${signingConfig?.storePassword != null} " +
                        "hasKeyPwd=${signingConfig?.keyPassword != null} " +
                        "storeType=${signingConfig?.storeType}"
                )
            }
        }
    }
}

flutter {
    source = "../.."
}

// ✅ Dependências para Play Store (Fused Location)
dependencies {
    implementation("com.google.android.gms:play-services-location:21.3.0")
    // (opcional) se algum plugin pedir base-tasks explicitamente, eles já vêm por transitividade.
}
