// Top-level build.gradle.kts (Android)

import org.gradle.api.tasks.Delete

// Centraliza a pasta build no topo do projeto (opcional)
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Redireciona o build de cada subprojeto
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    layout.buildDirectory.set(newSubprojectBuildDir)

    // Se tiver multi-módulo e precisar garantir ordem, pode habilitar:
    // project.evaluationDependsOn(":app")
}

// Task padrão de limpeza
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
