allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configuración de directorios de construcción de Flutter
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// SECCIÓN DE PLUGINS: Aquí es donde se activa Firebase para todo el proyecto
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Esta línea permite que el archivo google-services.json funcione
        classpath("com.google.gms:google-services:4.3.15")
    }
}