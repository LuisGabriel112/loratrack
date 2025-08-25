plugins {
    id("com.android.application")
    id("kotlin-android") 
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") 
}

android {
    namespace = "com.example.appturis"
    compileSdk = 35
    ndkVersion = "27.2.12479018"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.appturis"
        minSdk = 33
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

    dependencies {
        implementation(platform("com.google.firebase:firebase-bom:33.13.0"))
        implementation ("com.google.firebase:firebase-auth")
        implementation ("com.google.android.gms:play-services-auth:20.6.0")
        coreLibraryDesugaring ("com.android.tools:desugar_jdk_libs:2.0.3")
        implementation("com.google.firebase:firebase-analytics")
    }


flutter {
    source = "../.."
}
