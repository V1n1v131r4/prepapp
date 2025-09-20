allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Centraliza a pasta build no topo do projeto (economiza espaço em monorepo/Flutter)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // Redireciona o build de cada subprojeto
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    layout.buildDirectory.value(newSubprojectBuildDir)

    // Garante que o :app seja avaliado (útil para alguns plugins)
    project.evaluationDependsOn(":app")

    // Exclui dependências não-FLOSS de TODOS os configurations (debug/release, compile/runtime)
    configurations.configureEach {
        // GMS/Firebase
        exclude(group = "com.google.android.gms")
        exclude(group = "com.google.firebase")

        // Play Core (fonte das classes com.google.android.play.core.*)
        exclude(group = "com.google.android.play")
        exclude(group = "com.google.android.play", module = "core")
        exclude(group = "com.google.android.play", module = "core-common")

        // Cinto de segurança: se algum plugin tentar reintroduzir, falha o build
        resolutionStrategy.eachDependency {
            if (requested.group == "com.google.android.play") {
                throw GradleException("Dependência proibida detectada em subprojeto '${project.name}': ${requested.group}:${requested.name}:${requested.version}")
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
