import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val localProperties = Properties().apply {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        load(FileInputStream(localPropertiesFile))
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.hdi365.oder"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }

    defaultConfig { 
        minSdk = 23
        targetSdk = 36
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("prodrelease") {
            keystoreProperties["storeFile"]?.let {
                storeFile = file(it.toString())
            }
            storePassword = keystoreProperties["storePassword"]?.toString()
            keyAlias = keystoreProperties["keyAlias"]?.toString()
            keyPassword = keystoreProperties["keyPassword"]?.toString()
        }
    }

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
            isDebuggable = true
        }
        getByName("release") {
            isMinifyEnabled = true
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("prodrelease")
        }
    }

    flavorDimensions("environment")
    productFlavors {
        create("staging") {
            dimension = "environment"
            // applicationIdSuffix = ".staging"
            applicationId = "com.hdi365.oderstaging"
            buildConfigField("String", "FLAVOR_environment", "\"uat\"")
            resValue("string", "app_name", "Oder UAT")
            resValue("string", "api_url", "https://uat-loyalty.oder-app.com")
            resValue("string", "api_username", "eaba46692c32657b4e8acd1c995b86c317781965")
            resValue("string", "api_password", "f3af3db6e92aafd94eb9ec0e4409894af8c57099")
            resValue("string", "applink", "suat.oder-app.com")
            manifestPlaceholders.put("appName", "Oder UAT")
        }
        create("production") {
            dimension = "environment"
            applicationId = "com.hdi365.oder"
            buildConfigField("String", "FLAVOR_environment", "\"production\"")
            resValue("string", "app_name", "Oder")
            resValue("string", "api_url", "https://loyalty.oder-app.com")
            resValue("string", "api_username", "5397629a986981820468d5b1c5e3a7ad1be0094b")
            resValue("string", "api_password", "eb1a32d90c1ab82aae54548d2d3081b6ffdbbe4c")
            resValue("string", "applink", "s.oder-app.com")
            manifestPlaceholders.put("appName", "Oder")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.10")
    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-dynamic-links-ktx")
    implementation("com.google.firebase:firebase-analytics-ktx")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
}
