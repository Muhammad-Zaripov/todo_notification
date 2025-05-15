allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Root project uchun build papkasini o'zgartirish
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build")
rootProject.layout.buildDirectory.set(newBuildDir)

// subprojects uchun buildDirectory ni o'zgartirmaymiz (odatda bu kerak emas)
subprojects {
    evaluationDependsOn(":app")
}

// clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
