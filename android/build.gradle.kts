import com.android.build.gradle.AppExtension
import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Add this to resolve issue namespace is not specified.
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            val androidExtension = project.extensions.getByName("android")
        
            if (androidExtension is AppExtension) {
                val appExtension = androidExtension as AppExtension
                if (appExtension.namespace == null) {
                    appExtension.namespace = project.group.toString()
                }
            } else if (androidExtension is LibraryExtension) {
                val libraryExtension = androidExtension as LibraryExtension
                if (libraryExtension.namespace == null) {
                    libraryExtension.namespace = project.group.toString()
                }
            }
        } 
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
