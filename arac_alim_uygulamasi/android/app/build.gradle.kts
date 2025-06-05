// File: android/app/build.gradle.kts

plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.arac_alim_uygulamasi"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.arac_alim_uygulamasi"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            // Eğer release için ayrıca saklamak istediğiniz bir imza dosyanız yoksa,
            // debug imzasını kullanmaya devam edin:
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core library desugaring (Java 8 API’lerini kullanmak için)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // AndroidX WorkManager (arka plan görevleri)
    implementation("androidx.work:work-runtime-ktx:2.8.1")

    // Diğer temel AndroidX bağımlılıkları
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.7.10")
    implementation("androidx.core:core-ktx:1.9.0")
    implementation("androidx.appcompat:appcompat:1.5.1")
    implementation("com.google.android.material:material:1.7.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // Eğer hala Firebase Auth kullanacaksanız, aşağıdaki satırı açabilirsiniz:
    // implementation("com.google.firebase:firebase-auth-ktx:22.0.0")

    // Flutter Local Notifications eklentisi, platforma özel bir bağımlılık gerektirmez:
    // Sadece Dart tarafındaki paketleri pubspec.yaml'de ekleyin; Gradle’de ekstra bir satır eklemenize gerek yok.

    // (Eğer başka Android kütüphaneleri eklediyseniz, onları da buraya ekleyin)
}
