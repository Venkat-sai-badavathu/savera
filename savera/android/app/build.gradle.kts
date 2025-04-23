plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.savera"
    ndkVersion = "27.0.12077973"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
         
        isCoreLibraryDesugaringEnabled = true
      
        // coreLibraryDesugaringEnabled = true

       
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
       applicationId = "com.example.savera"
        minSdk = 23
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Add desugaring support library
     coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
