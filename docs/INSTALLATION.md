# 📦 Guide d'Installation — MobMovizz

Ce guide vous accompagne pas à pas dans l'installation et la configuration de l'environnement de développement pour MobMovizz.

## Table des matières

- [Prérequis système](#prérequis-système)
- [Installation de Flutter](#installation-de-flutter)
- [Clonage du projet](#clonage-du-projet)
- [Configuration de l'API TMDB](#configuration-de-lapi-tmdb)
- [Installation des dépendances](#installation-des-dépendances)
- [Configuration Android](#configuration-android)
- [Configuration iOS](#configuration-ios)
- [Vérification de l'installation](#vérification-de-linstallation)
- [Lancement de l'application](#lancement-de-lapplication)
- [Résolution des problèmes courants](#résolution-des-problèmes-courants)

## Prérequis système

### Logiciels requis

| Outil | Version minimale | Installation |
|-------|-----------------|--------------|
| **Flutter SDK** | ≥ 3.4.4 | [flutter.dev/get-started](https://docs.flutter.dev/get-started/install) |
| **Dart SDK** | ≥ 3.4.4 | Inclus avec Flutter |
| **Git** | Dernière version | [git-scm.com](https://git-scm.com/) |
| **Java JDK** | 17 | [adoptium.net](https://adoptium.net/) |
| **Android Studio** | Dernière version | [developer.android.com](https://developer.android.com/studio) |
| **Xcode** (macOS) | Dernière version | App Store |

### Configuration matérielle recommandée

- **RAM** : 8 Go minimum (16 Go recommandé)
- **Espace disque** : 10 Go minimum disponible
- **Processeur** : x64 ou ARM64

## Installation de Flutter

### macOS / Linux

```bash
# Télécharger Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Ajouter Flutter au PATH (ajouter dans ~/.bashrc ou ~/.zshrc)
export PATH="$PATH:$(pwd)/flutter/bin"

# Vérifier l'installation
flutter doctor
```

### Windows

1. Téléchargez le SDK Flutter depuis [flutter.dev](https://docs.flutter.dev/get-started/install/windows)
2. Extrayez l'archive dans un répertoire (ex. `C:\flutter`)
3. Ajoutez `C:\flutter\bin` au PATH système
4. Exécutez `flutter doctor` dans un terminal

### Vérification

```bash
flutter doctor -v
```

Assurez-vous que tous les éléments sont validés (✓) :

```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain
[✓] Android Studio
[✓] VS Code (ou votre éditeur)
```

## Clonage du projet

```bash
# Cloner le dépôt
git clone https://github.com/cheic/mobmovizz.git

# Accéder au répertoire du projet
cd mobmovizz
```

## Configuration de l'API TMDB

L'application utilise l'API [TMDB (The Movie Database)](https://www.themoviedb.org/) pour récupérer les données des films.

### 1. Créer un compte TMDB

1. Rendez-vous sur [themoviedb.org](https://www.themoviedb.org/)
2. Créez un compte gratuit
3. Accédez aux **Paramètres** → **API**
4. Demandez une clé API (type : développeur)
5. Copiez votre **Bearer Token** (API Read Access Token)

### 2. Créer le fichier de constantes

Créez le fichier `lib/core/utils/constants.dart` :

```dart
class Constants {
  // URL de base de l'API TMDB v3
  static const String apiUrl = 'https://api.themoviedb.org/3/';
  
  // Votre Bearer Token TMDB (API Read Access Token)
  static const String token = 'VOTRE_BEARER_TOKEN_ICI';
  
  // URL de base pour les images TMDB
  static const String imageUrl = 'https://image.tmdb.org/t/p/w500';
}
```

> ⚠️ **Sécurité** : Ce fichier est automatiquement exclu du contrôle de version via `.gitignore`. Ne partagez jamais votre token API.

## Installation des dépendances

```bash
# Installer les dépendances Flutter
flutter pub get

# Générer les fichiers de localisation
flutter gen-l10n
```

## Configuration Android

### SDK Android

1. Ouvrez **Android Studio** → **SDK Manager**
2. Installez :
   - Android SDK Platform 34 (ou supérieur)
   - Android SDK Build-Tools 34
   - Android SDK Command-line Tools

### Émulateur Android

1. Ouvrez **Android Studio** → **AVD Manager**
2. Créez un appareil virtuel :
   - Appareil : Pixel 7 (recommandé)
   - Image : API 34 (Android 14)
   - RAM : 2048 Mo minimum

### Configuration de signature (optionnel, pour la production)

Pour générer des APK signés :

1. Créez un keystore :

```bash
keytool -genkey -v -keystore android/app/release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias votre_alias
```

2. Créez `android/key.properties` :

```properties
storeFile=release-key.jks
storePassword=votre_mot_de_passe
keyAlias=votre_alias
keyPassword=votre_mot_de_passe_cle
```

> ⚠️ Ces fichiers sont exclus du contrôle de version via `.gitignore`.

### Configuration du keystore pour le CI/CD

Pour que le pipeline GitHub Actions puisse signer l'APK automatiquement, vous devez stocker votre keystore en tant que secret GitHub encodé en base64.

#### Étape 1 — Encoder le keystore en base64

```bash
# macOS / Linux
base64 -i /chemin/vers/votre/mobmovizz.jks | tr -d '\n'
```

Copiez la sortie complète de cette commande.

#### Étape 2 — Ajouter les secrets dans GitHub

Accédez à votre dépôt GitHub → **Settings** → **Secrets and variables** → **Actions**, puis ajoutez les secrets suivants :

| Secret | Valeur |
|--------|--------|
| `KEYSTORE_BASE64` | La sortie base64 de l'étape 1 |
| `KEYSTORE_PASSWORD` | Le mot de passe de votre keystore |
| `KEY_ALIAS` | L'alias de votre clé (ex. `votre_alias`) |
| `KEY_PASSWORD` | Le mot de passe de votre clé |
| `TMDB_TOKEN` | Votre Bearer Token API TMDB |

#### Étape 3 — Vérification

Poussez un commit sur la branche `main`. Le pipeline CI/CD :
1. Exécutera les tests
2. Décodera automatiquement le keystore depuis le secret `KEYSTORE_BASE64`
3. Créera le fichier `key.properties` avec les informations de signature
4. Compilera et signera l'APK de production
5. Mettra l'APK disponible en tant qu'artefact du workflow

> ⚠️ **Sécurité** : Ne commitez jamais votre fichier `.jks` ou `key.properties` dans le dépôt. Le fichier `.gitignore` est déjà configuré pour les exclure.

## Configuration iOS

> Note : La configuration iOS nécessite un Mac avec Xcode installé.

### 1. Installer les dépendances CocoaPods

```bash
cd ios
pod install
cd ..
```

### 2. Configurer Xcode

1. Ouvrez `ios/Runner.xcworkspace` dans Xcode
2. Sélectionnez la cible **Runner**
3. Configurez votre **Team** de développement dans l'onglet **Signing & Capabilities**
4. Configurez les permissions requises dans `Info.plist` :
   - Notifications
   - Géolocalisation
   - Accès Internet

## Vérification de l'installation

### Analyser le code

```bash
flutter analyze
```

### Lancer les tests

```bash
flutter test
```

### Vérifier la compilation

```bash
# Android
flutter build apk --debug

# iOS (macOS uniquement)
flutter build ios --debug --no-codesign
```

## Lancement de l'application

### Sur un émulateur Android

```bash
# Lister les appareils disponibles
flutter devices

# Lancer l'application
flutter run
```

### Sur un appareil physique

1. Activez le **mode développeur** et le **débogage USB** sur votre appareil
2. Connectez l'appareil via USB
3. Exécutez :

```bash
flutter run -d <id_appareil>
```

### Sur le simulateur iOS (macOS)

```bash
# Ouvrir le simulateur
open -a Simulator

# Lancer l'application
flutter run -d ios
```

### Mode Hot Reload

Une fois l'application lancée :
- Appuyez sur `r` pour le **Hot Reload** (rechargement à chaud)
- Appuyez sur `R` pour le **Hot Restart** (redémarrage complet)

## Résolution des problèmes courants

### ❌ `flutter pub get` échoue

```bash
# Nettoyer le cache et réinstaller
flutter clean
flutter pub cache repair
flutter pub get
```

### ❌ Erreur de version du SDK

Vérifiez que votre version de Flutter est compatible :

```bash
flutter --version
# Doit être ≥ 3.4.4

# Mettre à jour Flutter si nécessaire
flutter upgrade
```

### ❌ Erreur de compilation Android

```bash
# Nettoyer le build Android
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### ❌ Fichier `constants.dart` manquant

Si vous voyez une erreur liée à `constants.dart`, assurez-vous d'avoir créé le fichier comme décrit dans la section [Configuration de l'API TMDB](#configuration-de-lapi-tmdb).

### ❌ Erreur de localisation

Si les traductions ne fonctionnent pas :

```bash
flutter gen-l10n
flutter clean
flutter pub get
```

### ❌ Erreur CocoaPods (iOS)

```bash
cd ios
pod deintegrate
pod install --repo-update
cd ..
```

### ❌ Erreur de permissions (notifications, géolocalisation)

Vérifiez que les permissions sont correctement configurées :
- **Android** : `android/app/src/main/AndroidManifest.xml`
- **iOS** : `ios/Runner/Info.plist`

---

*Pour toute question supplémentaire, consultez la [documentation principale](../README.md) ou ouvrez une issue sur le dépôt GitHub.*
