// android/build.gradle.kts

// Minimalista. Sem buildscript/allprojects em Gradle 8+.
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
