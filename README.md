# 🎬 MobMovizz

**MobMovizz** est une application mobile Flutter permettant de découvrir, rechercher et gérer un catalogue de films. L'application offre une expérience utilisateur moderne avec un design Material 3, des animations fluides et une gestion complète des films.
**MobMovizz** est une application mobile Flutter permettant de découvrir, rechercher et gérer un catalogue de films. L'application offre une expérience utilisateur moderne avec un design Material 3, des animations fluides et une gestion complète des films.

## 📋 Table des matières

- [Fonctionnalités](#-fonctionnalités)
- [Captures d'écran](#-captures-décran)
- [Technologies utilisées](#-technologies-utilisées)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Lancement](#-lancement)
- [Architecture](#-architecture)
- [Structure du projet](#-structure-du-projet)
- [Tests](#-tests)
- [CI/CD](#-cicd)
- [Localisation](#-localisation)
- [Contribution](#-contribution)
- [Documentation complémentaire](#-documentation-complémentaire)

## ✨ Fonctionnalités

| Fonctionnalité | Description |
|---|---|
| 🏠 **Accueil** | Films populaires en carrousel héro, films à venir et mieux notés |
| 🎭 **Genres** | Parcourir les films par genre avec filtres et tri |
| 🔍 **Recherche** | Recherche textuelle de films en temps réel |
| 💾 **Watchlist** | Ajouter et gérer une liste de films à regarder |
| 🔔 **Notifications** | Rappels programmés pour les films (date et heure) |
| 🌍 **Localisation** | Interface disponible en anglais et en français |
| 🎨 **Thèmes** | Mode clair et mode sombre |
| 🎬 **Vidéos** | Lecteur YouTube intégré pour les bandes-annonces |
| 📍 **Géolocalisation** | Fournisseurs de streaming régionaux |
| ⚡ **Hors-ligne** | Détection de connexion et gestion des erreurs réseau |

## 📸 Captures d'écran

> *Les captures d'écran de l'application seront ajoutées ici.*

## 🛠 Technologies utilisées

### Framework
- **Flutter** 3.x (SDK Dart ≥ 3.4.4)
- **Material Design 3**

### Gestion d'état
- **flutter_bloc** / **bloc** — Pattern BLoC (Business Logic Component)
- **get_it** — Injection de dépendances (Service Locator)

### Réseau
- **dio** — Client HTTP
- **pretty_dio_logger** — Journalisation des requêtes réseau
- **internet_connection_checker** — Vérification de la connectivité

### Interface utilisateur
- **carousel_slider_plus** — Carrousels interactifs
- **cached_network_image** — Gestion optimisée des images
- **google_fonts** — Typographie Plus Jakarta Sans
- **flutter_platform_widgets** — Widgets adaptatifs iOS/Android

### Fonctionnalités
- **youtube_player_iframe** — Lecteur vidéo YouTube
- **geolocator** / **geocoding** — Services de géolocalisation
- **flutter_local_notifications** — Notifications locales
- **shared_preferences** — Stockage local persistant
- **permission_handler** — Gestion des permissions

### Utilitaires
- **dartz** — Programmation fonctionnelle (`Either`, `Option`)
- **equatable** — Comparaison d'objets simplifiée
- **intl** — Internationalisation et formatage

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir installé les outils suivants :

- **Flutter SDK** ≥ 3.4.4 ([Guide d'installation](https://docs.flutter.dev/get-started/install))
- **Dart SDK** ≥ 3.4.4 (inclus avec Flutter)
- **Android Studio** ou **VS Code** avec les extensions Flutter/Dart
- **Java JDK** 17 (pour le build Android)
- **Git**

Vérifiez votre installation :

```bash
flutter doctor
```

## 🚀 Installation

### 1. Cloner le dépôt

```bash
git clone https://github.com/cheic/mobmovizz.git
cd mobmovizz
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Générer les fichiers de localisation

```bash
flutter gen-l10n
```

## ⚙️ Configuration

### Clé API TMDB

L'application utilise l'API [TMDB (The Movie Database)](https://www.themoviedb.org/documentation/api). Vous devez créer un fichier de constantes avec votre clé API :

1. Créez le fichier `lib/core/utils/constants.dart`
2. Ajoutez votre configuration :

```dart
class Constants {
  static const String apiUrl = 'https://api.themoviedb.org/3/';
  static const String token = 'VOTRE_TOKEN_API_TMDB';
  static const String imageUrl = 'https://image.tmdb.org/t/p/w500';
}
```

> ⚠️ **Important** : Ce fichier est exclu du contrôle de version via `.gitignore` pour protéger vos clés API.

### Configuration Android (optionnel)

Pour la signature de l'APK en production, créez le fichier `android/key.properties` :

```properties
storeFile=chemin/vers/votre/keystore.jks
storePassword=votre_mot_de_passe
keyAlias=votre_alias
keyPassword=votre_mot_de_passe_cle
```

## ▶️ Lancement

### Mode développement

```bash
# Android
flutter run

# iOS
flutter run -d ios

# Web (si configuré)
flutter run -d chrome
```

### Build de production

```bash
# APK Android
flutter build apk --release

# App Bundle Android
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🏗 Architecture

L'application suit le pattern **Clean Architecture** avec le pattern **BLoC** pour la gestion d'état :

```
┌─────────────────────────────────────────────────┐
│                  Présentation                   │
│          (Widgets, Pages, BLoC/Cubit)           │
├─────────────────────────────────────────────────┤
│                 Logique Métier                  │
│              (BLoCs, Events, States)            │
├─────────────────────────────────────────────────┤
│                    Données                      │
│          (Services, Modèles, API)               │
├─────────────────────────────────────────────────┤
│                      Core                       │
│    (DI, Réseau, Thèmes, Widgets communs)        │
└─────────────────────────────────────────────────┘
```

### Flux de données

```
UI (Widget) → Event → BLoC → Service → API
                              ↓
UI (Widget) ← State ← BLoC ← Either<Failure, Data>
```

Le pattern `Either` (du package `dartz`) est utilisé pour gérer les erreurs de manière fonctionnelle : chaque appel réseau retourne soit un `Failure` (erreur), soit les données attendues.

> 📖 Pour plus de détails, consultez la [documentation d'architecture](docs/ARCHITECTURE.md).

## 📁 Structure du projet

```
lib/
├── main.dart                        # Point d'entrée de l'application
├── core/                            # Modules transversaux
│   ├── di/                          # Injection de dépendances (GetIt)
│   │   └── injection.dart
│   ├── error/                       # Gestion des erreurs
│   │   └── failure.dart
│   ├── network/                     # Couche réseau
│   │   ├── api_service.dart         # Client API centralisé
│   │   ├── dio_factory.dart         # Configuration Dio
│   │   └── network_info.dart        # Vérification connectivité
│   ├── theme/                       # Thèmes Material 3
│   │   ├── app_themes.dart          # Thèmes clair et sombre
│   │   ├── theme_bloc.dart          # BLoC de gestion du thème
│   │   ├── colors.dart              # Palette de couleurs
│   │   └── text_theme.dart          # Typographie
│   ├── services/                    # Services applicatifs
│   │   ├── notification_service.dart # Notifications locales
│   │   ├── localization_service.dart # Service de localisation
│   │   └── provider_service.dart    # Fournisseurs de streaming
│   ├── utils/                       # Utilitaires
│   │   ├── app_preferences.dart     # Préférences utilisateur
│   │   ├── date_formatter.dart      # Formatage des dates
│   │   ├── currency_formatter.dart  # Formatage des devises
│   │   └── rating.dart              # Affichage des notes
│   ├── widgets/                     # Widgets réutilisables
│   │   ├── navigation/             # Navigation Material 3
│   │   ├── error_handler_widget.dart
│   │   ├── state_widgets.dart
│   │   └── ...
│   └── common/                      # Composants communs
│       ├── app_dimensions.dart      # Espacements Material 3
│       └── common_header.dart       # En-têtes de section
│
├── features/                        # Fonctionnalités métier
│   ├── home/                        # Écran d'accueil
│   │   ├── popular_movies/         # Films populaires
│   │   │   ├── bloc/               # BLoC, Events, States
│   │   │   ├── data/               # Service + Modèles
│   │   │   └── view/               # UI
│   │   ├── upcomings/              # Films à venir
│   │   └── top_rated/              # Films les mieux notés
│   ├── genres/                      # Gestion des genres
│   │   ├── movies_genre_list/      # Liste des genres
│   │   └── movies_by_genre/        # Films par genre
│   ├── search/                      # Recherche de films
│   ├── movie_details/              # Détails d'un film
│   ├── watchlist/                   # Liste de surveillance
│   └── favorites/                   # Films favoris
│
├── l10n/                            # Fichiers de localisation
│   ├── app_en.arb                   # Traductions anglaises
│   ├── app_fr.arb                   # Traductions françaises
│   └── app_localizations.dart       # Classes générées
```

## 🧪 Tests

### Lancer les tests

```bash
# Tous les tests
flutter test

# Un fichier de test spécifique
flutter test test/currency_formatter_test.dart

# Avec couverture
flutter test --coverage
```

### Tests disponibles

| Fichier | Description |
|---------|-------------|
| `test/currency_formatter_test.dart` | Tests du formatage des devises (K, M, B) |
| `test/notification_date_validator_test.dart` | Tests de validation des dates de notification |
| `test/watchlist_item_test.dart` | Tests de sérialisation JSON de la watchlist |
| `test/widget_test.dart` | Test de base des widgets |

## 🔄 CI/CD

Le projet utilise **GitHub Actions** pour l'intégration et le déploiement continus :

### Pipeline

```
Push sur main → Tests → Build App Bundle signé → Artefact
```

### Jobs

1. **Build & Test** — Exécute `flutter test` sur Ubuntu
2. **Build & Release Android** — Compile et signe l'App Bundle (`.aab`) de production

### Secrets requis

| Secret | Description |
|--------|-------------|
| `TMDB_TOKEN` | Token d'accès API TMDB (Bearer Token) |
| `MOBMOVIZZ_KEYSTORE` | Fichier keystore encodé en base64 |
| `KEYSTORE_PASSWORD` | Mot de passe du keystore |
| `KEY_ALIAS` | Alias de la clé de signature |
| `KEY_PASSWORD` | Mot de passe de la clé |

### Configuration du keystore pour le CI/CD

Le fichier keystore (`.jks`) ne doit **jamais** être commité dans le dépôt. Pour le CI/CD, il est stocké sous forme encodée en base64 dans les GitHub Secrets.

#### 1. Encoder le keystore en base64

```bash
base64 -i /chemin/vers/votre/mobmovizz.jks | tr -d '\n'
```

> Par exemple, si votre fichier est situé à `/Users/aki/Documents/dev/keys/mobmovizz.jks` :
>
> ```bash
> base64 -i /Users/aki/Documents/dev/keys/mobmovizz.jks | tr -d '\n'
> ```

#### 2. Ajouter les secrets dans GitHub

1. Accédez à votre dépôt GitHub → **Settings** → **Secrets and variables** → **Actions**
2. Cliquez sur **New repository secret** et ajoutez chaque secret :
   - `MOBMOVIZZ_KEYSTORE` : collez la sortie de la commande `base64` ci-dessus
   - `KEYSTORE_PASSWORD` : le mot de passe de votre keystore
   - `KEY_ALIAS` : l'alias de votre clé (ex. `votre_alias`)
   - `KEY_PASSWORD` : le mot de passe de votre clé
   - `TMDB_TOKEN` : votre Bearer Token TMDB

> ⚠️ **Important** : Ne stockez jamais le fichier `.jks` dans le dépôt Git. Le pipeline CI/CD décode automatiquement le secret `MOBMOVIZZ_KEYSTORE` pour recréer le fichier keystore lors du build.

## 🌐 Localisation

L'application supporte deux langues :

- 🇬🇧 **Anglais** (par défaut)
- 🇫🇷 **Français**

Les fichiers de traduction se trouvent dans `lib/l10n/` au format ARB (Application Resource Bundle).

### Ajouter une traduction

1. Ajoutez la clé dans `lib/l10n/app_en.arb` (template)
2. Ajoutez la traduction dans `lib/l10n/app_fr.arb`
3. Régénérez les fichiers :

```bash
flutter gen-l10n
```

4. Utilisez dans le code :

```dart
AppLocalizations.of(context)!.votreCle
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Consultez le [guide de contribution](docs/CONTRIBUTION.md) pour plus de détails.

### En résumé

1. Forkez le projet
2. Créez votre branche (`git checkout -b feature/ma-fonctionnalite`)
3. Committez vos changements (`git commit -m 'feat: ajout de ma fonctionnalité'`)
4. Poussez la branche (`git push origin feature/ma-fonctionnalite`)
5. Ouvrez une Pull Request

## 📚 Documentation complémentaire

| Document | Description |
|----------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | Architecture technique détaillée |
| [Installation](docs/INSTALLATION.md) | Guide d'installation complet |
| [Contribution](docs/CONTRIBUTION.md) | Guide de contribution |

## 📄 Licence

Ce projet est un projet privé. Tous droits réservés.

---

*Développé avec ❤️ en Flutter*
