# 🏗 Architecture Technique — MobMovizz

Ce document décrit l'architecture technique de l'application MobMovizz, une application Flutter de catalogue de films.

## Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Pattern architectural](#pattern-architectural)
- [Couches de l'application](#couches-de-lapplication)
- [Injection de dépendances](#injection-de-dépendances)
- [Gestion d'état avec BLoC](#gestion-détat-avec-bloc)
- [Couche réseau](#couche-réseau)
- [Navigation](#navigation)
- [Thèmes et design](#thèmes-et-design)
- [Gestion des erreurs](#gestion-des-erreurs)
- [Services applicatifs](#services-applicatifs)
- [Modèles de données](#modèles-de-données)

## Vue d'ensemble

MobMovizz utilise une **architecture en couches** inspirée de la Clean Architecture, combinée avec le pattern **BLoC** (Business Logic Component) pour la gestion d'état.

```
┌───────────────────────────────────────────────────────────────┐
│                      PRÉSENTATION                             │
│   Widgets ─ Pages ─ Dialogues ─ Animations                   │
│                         │                                     │
│                    ┌────▼────┐                                │
│                    │  BLoC   │   Events → BLoC → States       │
│                    └────┬────┘                                │
├─────────────────────────┼─────────────────────────────────────┤
│                   LOGIQUE MÉTIER                              │
│              Services ─ Validateurs                           │
│                         │                                     │
├─────────────────────────┼─────────────────────────────────────┤
│                      DONNÉES                                  │
│           API Service ─ Modèles ─ Préférences                │
│                         │                                     │
├─────────────────────────┼─────────────────────────────────────┤
│                       CORE                                    │
│      DI ─ Réseau ─ Thèmes ─ Utilitaires ─ Widgets communs   │
└───────────────────────────────────────────────────────────────┘
```

## Pattern architectural

### Clean Architecture adaptée

L'application organise le code en **fonctionnalités** (*features*), chacune contenant ses propres couches :

```
features/
└── nom_fonctionnalite/
    ├── bloc/           # Logique métier (BLoC, Events, States)
    ├── data/           # Données (Services API, Modèles)
    │   ├── models/     # Classes de données sérialisables
    │   └── service/    # Appels API
    └── view/           # Interface utilisateur
```

### Principes respectés

- **Séparation des responsabilités** : Chaque couche a un rôle précis
- **Inversion de dépendances** : Les couches hautes ne dépendent pas des couches basses directement
- **Single Responsibility** : Un BLoC par fonctionnalité métier
- **Immutabilité des états** : Les états BLoC sont immuables (via `Equatable`)

## Couches de l'application

### 1. Couche Core (`lib/core/`)

Contient les modules transversaux utilisés par l'ensemble de l'application :

| Module | Rôle | Fichiers clés |
|--------|------|---------------|
| `di/` | Injection de dépendances | `injection.dart` |
| `error/` | Types d'erreurs | `failure.dart` |
| `network/` | Communication réseau | `api_service.dart`, `dio_factory.dart` |
| `theme/` | Système de thèmes | `app_themes.dart`, `theme_bloc.dart` |
| `services/` | Services métier | `notification_service.dart`, `localization_service.dart` |
| `utils/` | Utilitaires | `date_formatter.dart`, `currency_formatter.dart` |
| `widgets/` | Widgets réutilisables | `state_widgets.dart`, `error_handler_widget.dart` |
| `common/` | Composants communs | `app_dimensions.dart`, `common_header.dart` |

### 2. Couche Features (`lib/features/`)

Chaque fonctionnalité est isolée et auto-contenue :

| Feature | Description | BLoC |
|---------|-------------|------|
| `home/popular_movies` | Films populaires | `PopularMoviesBloc` |
| `home/upcomings` | Films à venir | `UpcomingsBloc` |
| `home/top_rated` | Films mieux notés | `TopRatedBloc` |
| `genres/movies_genre_list` | Liste des genres | `MovieGenresBloc` |
| `genres/movies_by_genre` | Films par genre | `MoviesByGenreBloc` |
| `search` | Recherche de films | `SearchMovieBloc` |
| `movie_details` | Détails d'un film | `MovieDetailsBloc` |
| `watchlist` | Liste de surveillance | `WatchlistBloc` |
| `favorites` | Films favoris | `FavoritesBloc` |

### 3. Couche Widgets (`lib/widgets/`)

Widgets spécifiques aux features, non réutilisables globalement :

- `upcoming_widget.dart` — Widget des films à venir
- `quick_add_widget.dart` — Ajout rapide à la watchlist
- `watchlist_widget.dart` — Affichage de la watchlist

## Injection de dépendances

L'application utilise **GetIt** comme Service Locator pour l'injection de dépendances.

### Configuration (`lib/core/di/injection.dart`)

```dart
Future<void> initInjection() async {
  // 1. Stockage local
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // 2. Préférences applicatives
  sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sharedPreferences));

  // 3. BLoCs
  sl.registerFactory(() => ThemeBloc(sl<AppPreferences>()));

  // 4. Réseau
  sl.registerFactory<DioFactory>(() => DioFactory());
  final dio = await sl<DioFactory>().getDio();
  sl.registerLazySingleton<ApiService>(() => ApiService(dio));

  // 5. Services métier
  sl.registerLazySingleton(() => PopularMoviesService(sl<ApiService>()));
  // ...
}
```

### Cycle de vie des objets

| Type | Méthode | Usage |
|------|---------|-------|
| **Singleton paresseux** | `registerLazySingleton` | Services, API, Préférences |
| **Factory** | `registerFactory` | BLoCs (nouvelle instance par widget) |

### Initialisation

L'injection est initialisée dans `main.dart` avant le lancement de l'application :

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(/* ... */);
}
```

## Gestion d'état avec BLoC

### Pattern utilisé

Chaque fonctionnalité suit le cycle :

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Event   │────▶│   BLoC   │────▶│  State   │
└──────────┘     └──────────┘     └──────────┘
     ▲                                  │
     │                                  ▼
     └──────────── Widget ◀─────────────┘
```

### Exemple : Films populaires

**Event** (`popular_movies_event.dart`) :
```dart
abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();
}

class FetchPopularMovies extends PopularMoviesEvent { }
```

**State** (`popular_movies_state.dart`) :
```dart
class PopularMoviesInitial extends PopularMoviesState { }
class PopularMoviesLoading extends PopularMoviesState { }
class PopularMoviesLoaded extends PopularMoviesState {
  final PopularMovieModel popularMovieModel;
}
class PopularMoviesError extends PopularMoviesState {
  final String message;
}
```

**BLoC** (`popular_movies_bloc.dart`) :
```dart
class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final PopularMoviesService discoverService;

  PopularMoviesBloc(this.discoverService) : super(PopularMoviesInitial()) {
    on<FetchPopularMovies>(_onFetchMovies);
  }

  void _onFetchMovies(event, emit) async {
    emit(PopularMoviesLoading());
    final result = await discoverService.getPopularMovies();
    emit(result.fold(
      (failure) => PopularMoviesError(failure.message ?? ""),
      (data) => PopularMoviesLoaded(data),
    ));
  }
}
```

### MultiBlocProvider

Tous les BLoCs sont injectés au niveau racine de l'application :

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => GetIt.I<ThemeBloc>()),
    BlocProvider(create: (_) => NavigationCubit()),
    BlocProvider<PopularMoviesBloc>(
      create: (_) => PopularMoviesBloc(GetIt.I<PopularMoviesService>())
        ..add(FetchPopularMovies()),
    ),
    // ... autres BLoCs
  ],
  child: const MyApp(),
);
```

## Couche réseau

### Architecture réseau

```
┌─────────────┐     ┌───────────────┐     ┌──────────┐
│  Service    │────▶│  ApiService   │────▶│   Dio    │──▶ API TMDB
│  (Feature)  │     │  (Centralisé) │     │ (HTTP)   │
└─────────────┘     └───────────────┘     └──────────┘
```

### DioFactory (`lib/core/network/dio_factory.dart`)

Configure le client HTTP Dio avec :
- **URL de base** vers l'API TMDB
- **Timeouts** de connexion, réception et envoi (30 secondes)
- **Logger** des requêtes en mode debug (sans les en-têtes sensibles)

### ApiService (`lib/core/network/api_service.dart`)

Service centralisé pour toutes les requêtes HTTP :
- Méthodes : `GET`, `POST`, `PUT`, `DELETE`
- Gestion automatique des en-têtes d'autorisation
- Support du paramètre de langue pour l'internationalisation

### Services métier

Chaque fonctionnalité possède son propre service qui utilise `ApiService` :

```dart
class PopularMoviesService {
  final ApiService _apiService;

  Future<Either<Failure, PopularMovieModel>> getPopularMovies() async {
    try {
      final response = await _apiService.get(endPoint: 'movie/popular');
      return Right(PopularMovieModel.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
```

### Gestion des erreurs réseau

Le pattern `Either` (package `dartz`) est utilisé systématiquement :

```dart
Either<Failure, Data>
├── Left(Failure)   → Erreur (réseau, serveur, parsing)
└── Right(Data)     → Succès avec les données
```

Types d'erreurs (`lib/core/error/failure.dart`) :
- `ServerFailure` — Erreur serveur ou réseau
- `CacheFailure` — Erreur de cache local

## Navigation

### Structure de navigation

L'application utilise un `IndexedStack` avec une barre de navigation **Material 3 NavigationBar** :

```
┌──────────────────────────────────────┐
│            IndexedStack              │
│  ┌────────────────────────────────┐  │
│  │  [0] Accueil (Discover)       │  │
│  │  [1] Genres                   │  │
│  │  [2] Recherche                │  │
│  │  [3] Watchlist                │  │
│  └────────────────────────────────┘  │
├──────────────────────────────────────┤
│    Material 3 NavigationBar (4)      │
│    🏠  🎭  🔍  💾                    │
└──────────────────────────────────────┘
```

### NavigationCubit

La navigation est gérée par un `Cubit` simple :

```dart
class NavigationCubit extends Cubit<NavigationState> {
  void getNavBarItem(NavbarItem item) {
    emit(NavigationState(item, item.index));
  }
}
```

### Material 3 NavigationBar

La barre de navigation utilise le composant natif `NavigationBar` de Material 3, stylisé via `NavigationBarThemeData` dans le thème de l'application pour une intégration visuelle cohérente.

## Thèmes et design

### Material Design 3

L'application utilise le système de design Material 3 avec deux thèmes :

- **Thème clair** — Fond clair, contrastes doux
- **Thème sombre** — Fond sombre, contrastes optimisés

### Palette de couleurs

| Couleur | Hex | Usage |
|---------|-----|-------|
| Royal Blue | `#3B6FED` | Couleur primaire |
| Royal Blue Derived | `#5B8AF5` | Variante primaire |
| Accent Amber | `#FFB81C` | Couleur d'accentuation |
| Surface Dim | `#0D1117` | Fond sombre |
| Lotion | `#F6F8FA` | Fond clair |
| Snow | `#F0F3F6` | Surface claire secondaire |

### ThemeBloc

Le changement de thème est géré par un BLoC dédié avec persistance via `SharedPreferences` :

```dart
// Modes disponibles : 0 = Système, 1 = Clair, 2 = Sombre
ThemeBloc → ThemeState(themeMode) → ThemeMode.system/light/dark
```

### Typographie

L'application utilise la police **Plus Jakarta Sans** chargée via Google Fonts, appliquée à l'ensemble du `TextTheme` pour une typographie moderne et premium.

## Gestion des erreurs

### Widgets d'état

L'application dispose de widgets dédiés pour chaque état :

| Widget | Usage |
|--------|-------|
| `LoadingStateWidget` | Indicateur de chargement |
| `ErrorStateWidget` | Affichage d'erreur avec bouton réessayer |
| `EmptyStateWidget` | État vide personnalisable |
| `NoInternetWidget` | Pas de connexion internet |
| `NoSearchResultsWidget` | Aucun résultat de recherche |

### ErrorHandlerWidget

Widget intelligent qui détecte le type d'erreur (réseau, serveur, générique) et affiche le message approprié. Utilisé de manière cohérente dans toutes les pages (Genres, Recherche, etc.).

### Stratégie d'erreur par section

Sur la page d'accueil, les erreurs sont gérées de manière hiérarchique :
- **Erreur principale** (Popular Movies) : affiche un `ErrorHandlerWidget` en plein écran au niveau du `body`
- **Erreurs secondaires** (TopRated, Upcoming) : retournent `SizedBox.shrink()` pour ne pas bloquer l'affichage

### SectionErrorWrapper

Wrapper qui encapsule un contenu et affiche un fallback en cas d'erreur, avec une version compacte disponible.

## Services applicatifs

### NotificationService

Service de notifications locales :
- Initialisation avec support des fuseaux horaires
- Programmation de rappels pour les films
- Gestion des permissions (Android/iOS)
- Notifications de test

### LocalizationService

Conversion des locales Flutter vers le format TMDB API :
- `fr` → `fr-FR`
- `en` → `en-US`
- Détection automatique de la langue de l'appareil

### ProviderService

Base de données des fournisseurs de streaming par pays :
- Listes régionales (Netflix, Amazon Prime, Disney+, etc.)
- Support de 18+ pays
- Intégration avec la géolocalisation

## Modèles de données

### Sérialisation JSON

Tous les modèles utilisent des factories `fromJson` pour la désérialisation :

```dart
class PopularMovieModel {
  final int? page;
  final List<MovieResult>? results;
  final int? totalPages;

  factory PopularMovieModel.fromJson(Map<String, dynamic> json) {
    return PopularMovieModel(
      page: json['page'],
      results: (json['results'] as List?)
          ?.map((e) => MovieResult.fromJson(e))
          .toList(),
      totalPages: json['total_pages'],
    );
  }
}
```

### WatchlistItem

Le modèle `WatchlistItem` utilise une désérialisation sécurisée avec validation de types et valeurs par défaut :

```dart
factory WatchlistItem.fromJson(Map<String, dynamic> json) {
  final id = json['id'];
  return WatchlistItem(
    id: id is int ? id : (id is String ? int.tryParse(id) ?? 0 : 0),
    title: title is String ? title : 'Unknown',
    // ...
  );
}
```

### Stockage local

La watchlist est sérialisée en JSON et stockée dans `SharedPreferences` :

```dart
// Sauvegarde
await sharedPreferences.setString('watchlist', jsonEncode(jsonList));

// Lecture (avec gestion d'erreurs)
try {
  final jsonList = jsonDecode(jsonString) as List;
  return jsonList.whereType<Map<String, dynamic>>()
      .map((json) => WatchlistItem.fromJson(json))
      .toList();
} catch (e) {
  return [];
}
```

---

*Ce document est maintenu à jour avec l'évolution de l'architecture de MobMovizz.*
# 🏗 Architecture Technique — MobMovizz

Ce document décrit l'architecture technique de l'application MobMovizz, une application Flutter de catalogue de films.

## Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Pattern architectural](#pattern-architectural)
- [Couches de l'application](#couches-de-lapplication)
- [Injection de dépendances](#injection-de-dépendances)
- [Gestion d'état avec BLoC](#gestion-détat-avec-bloc)
- [Couche réseau](#couche-réseau)
- [Navigation](#navigation)
- [Thèmes et design](#thèmes-et-design)
- [Gestion des erreurs](#gestion-des-erreurs)
- [Services applicatifs](#services-applicatifs)
- [Modèles de données](#modèles-de-données)

## Vue d'ensemble

MobMovizz utilise une **architecture en couches** inspirée de la Clean Architecture, combinée avec le pattern **BLoC** (Business Logic Component) pour la gestion d'état.

```
┌───────────────────────────────────────────────────────────────┐
│                      PRÉSENTATION                             │
│   Widgets ─ Pages ─ Dialogues ─ Animations                   │
│                         │                                     │
│                    ┌────▼────┐                                │
│                    │  BLoC   │   Events → BLoC → States       │
│                    └────┬────┘                                │
├─────────────────────────┼─────────────────────────────────────┤
│                   LOGIQUE MÉTIER                              │
│              Services ─ Validateurs                           │
│                         │                                     │
├─────────────────────────┼─────────────────────────────────────┤
│                      DONNÉES                                  │
│           API Service ─ Modèles ─ Préférences                │
│                         │                                     │
├─────────────────────────┼─────────────────────────────────────┤
│                       CORE                                    │
│      DI ─ Réseau ─ Thèmes ─ Utilitaires ─ Widgets communs   │
└───────────────────────────────────────────────────────────────┘
```

## Pattern architectural

### Clean Architecture adaptée

L'application organise le code en **fonctionnalités** (*features*), chacune contenant ses propres couches :

```
features/
└── nom_fonctionnalite/
    ├── bloc/           # Logique métier (BLoC, Events, States)
    ├── data/           # Données (Services API, Modèles)
    │   ├── models/     # Classes de données sérialisables
    │   └── service/    # Appels API
    └── view/           # Interface utilisateur
```

### Principes respectés

- **Séparation des responsabilités** : Chaque couche a un rôle précis
- **Inversion de dépendances** : Les couches hautes ne dépendent pas des couches basses directement
- **Single Responsibility** : Un BLoC par fonctionnalité métier
- **Immutabilité des états** : Les états BLoC sont immuables (via `Equatable`)

## Couches de l'application

### 1. Couche Core (`lib/core/`)

Contient les modules transversaux utilisés par l'ensemble de l'application :

| Module | Rôle | Fichiers clés |
|--------|------|---------------|
| `di/` | Injection de dépendances | `injection.dart` |
| `error/` | Types d'erreurs | `failure.dart` |
| `network/` | Communication réseau | `api_service.dart`, `dio_factory.dart` |
| `theme/` | Système de thèmes | `app_themes.dart`, `theme_bloc.dart` |
| `services/` | Services métier | `notification_service.dart`, `localization_service.dart` |
| `utils/` | Utilitaires | `date_formatter.dart`, `currency_formatter.dart` |
| `widgets/` | Widgets réutilisables | `state_widgets.dart`, `error_handler_widget.dart` |
| `common/` | Composants communs | `app_dimensions.dart`, `button_tab.dart` |

### 2. Couche Features (`lib/features/`)

Chaque fonctionnalité est isolée et auto-contenue :

| Feature                   | Description | BLoC |
|---------------------------|-------------|------|
| `home/popular_movies`     | Films populaires | `PopularMoviesBloc` |
| `home/upcomings`          | Films à venir | `UpcomingsBloc` |
| `home/top_rated`          | Films mieux notés | `TopRatedBloc` |
| `genres/movies_genre_list`| Liste des genres | `MovieGenresBloc` |
| `genres/movies_by_genre`  | Films par genre | `MoviesByGenreBloc` |
| `search`                  | Recherche de films | `SearchMovieBloc` |
| `movie_details`           | Détails d'un film | `MovieDetailsBloc` |
| `watchlist` | Liste de surveillance | `WatchlistBloc` |
| `favorites` | Films favoris | `FavoritesBloc` |

### 3. Couche Widgets (`lib/widgets/`)

Widgets spécifiques aux features, non réutilisables globalement :

- `upcoming_widget.dart` — Widget des films à venir
- `quick_add_widget.dart` — Ajout rapide à la watchlist
- `watchlist_widget.dart` — Affichage de la watchlist

## Injection de dépendances

L'application utilise **GetIt** comme Service Locator pour l'injection de dépendances.

### Configuration (`lib/core/di/injection.dart`)

```dart
Future<void> initInjection() async {
  // 1. Stockage local
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // 2. Préférences applicatives
  sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sharedPreferences));

  // 3. BLoCs
  sl.registerFactory(() => ThemeBloc(sl<AppPreferences>()));

  // 4. Réseau
  sl.registerFactory<DioFactory>(() => DioFactory());
  final dio = await sl<DioFactory>().getDio();
  sl.registerLazySingleton<ApiService>(() => ApiService(dio));

  // 5. Services métier
  sl.registerLazySingleton(() => PopularMoviesService(sl<ApiService>()));
  // ...
}
```

### Cycle de vie des objets

| Type | Méthode | Usage |
|------|---------|-------|
| **Singleton paresseux** | `registerLazySingleton` | Services, API, Préférences |
| **Factory** | `registerFactory` | BLoCs (nouvelle instance par widget) |

### Initialisation

L'injection est initialisée dans `main.dart` avant le lancement de l'application :

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(/* ... */);
}
```

## Gestion d'état avec BLoC

### Pattern utilisé

Chaque fonctionnalité suit le cycle :

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Event   │────▶│   BLoC   │────▶│  State   │
└──────────┘     └──────────┘     └──────────┘
     ▲                                  │
     │                                  ▼
     └──────────── Widget ◀─────────────┘
```

### Exemple : Films populaires

**Event** (`popular_movies_event.dart`) :
```dart
abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();
}

class FetchPopularMovies extends PopularMoviesEvent { }
```

**State** (`popular_movies_state.dart`) :
```dart
class PopularMoviesInitial extends PopularMoviesState { }
class PopularMoviesLoading extends PopularMoviesState { }
class PopularMoviesLoaded extends PopularMoviesState {
  final PopularMovieModel popularMovieModel;
}
class PopularMoviesError extends PopularMoviesState {
  final String message;
}
```

**BLoC** (`popular_movies_bloc.dart`) :
```dart
class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final PopularMoviesService discoverService;

  PopularMoviesBloc(this.discoverService) : super(PopularMoviesInitial()) {
    on<FetchPopularMovies>(_onFetchMovies);
  }

  void _onFetchMovies(event, emit) async {
    emit(PopularMoviesLoading());
    final result = await discoverService.getPopularMovies();
    emit(result.fold(
      (failure) => PopularMoviesError(failure.message ?? ""),
      (data) => PopularMoviesLoaded(data),
    ));
  }
}
```

### MultiBlocProvider

Tous les BLoCs sont injectés au niveau racine de l'application :

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => GetIt.I<ThemeBloc>()),
    BlocProvider(create: (_) => NavigationCubit()),
    BlocProvider<PopularMoviesBloc>(
      create: (_) => PopularMoviesBloc(GetIt.I<PopularMoviesService>())
        ..add(FetchPopularMovies()),
    ),
    // ... autres BLoCs
  ],
  child: const MyApp(),
);
```

## Couche réseau

### Architecture réseau

```
┌─────────────┐     ┌───────────────┐     ┌──────────┐
│  Service    │────▶│  ApiService   │────▶│   Dio    │──▶ API TMDB
│  (Feature)  │     │  (Centralisé) │     │ (HTTP)   │
└─────────────┘     └───────────────┘     └──────────┘
```

### DioFactory (`lib/core/network/dio_factory.dart`)

Configure le client HTTP Dio avec :
- **URL de base** vers l'API TMDB
- **Timeouts** de connexion, réception et envoi (30 secondes)
- **Logger** des requêtes en mode debug (sans les en-têtes sensibles)

### ApiService (`lib/core/network/api_service.dart`)

Service centralisé pour toutes les requêtes HTTP :
- Méthodes : `GET`, `POST`, `PUT`, `DELETE`
- Gestion automatique des en-têtes d'autorisation
- Support du paramètre de langue pour l'internationalisation

### Services métier

Chaque fonctionnalité possède son propre service qui utilise `ApiService` :

```dart
class PopularMoviesService {
  final ApiService _apiService;

  Future<Either<Failure, PopularMovieModel>> getPopularMovies() async {
    try {
      final response = await _apiService.get(endPoint: 'movie/popular');
      return Right(PopularMovieModel.fromJson(response.data));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
```

### Gestion des erreurs réseau

Le pattern `Either` (package `dartz`) est utilisé systématiquement :

```dart
Either<Failure, Data>
├── Left(Failure)   → Erreur (réseau, serveur, parsing)
└── Right(Data)     → Succès avec les données
```

Types d'erreurs (`lib/core/error/failure.dart`) :
- `ServerFailure` — Erreur serveur ou réseau
- `CacheFailure` — Erreur de cache local

## Thèmes et design

### Material Design 3

L'application utilise le système de design Material 3 avec deux thèmes :

- **Thème clair** — Fond clair, contrastes doux
- **Thème sombre** — Fond sombre, contrastes optimisés

### Palette de couleurs

| Couleur     | Hex       | Usage            |
|-------------|-----------|------------------|
| Royal Blue  | `#4169E1` | Couleur primaire |
| Surface Dim | `#111318` | Fond sombre      |
| Snow        | `#FFFAFA` | Fond clair       |

### ThemeBloc

Le changement de thème est géré par un BLoC dédié avec persistance via `SharedPreferences` :

```dart
// Modes disponibles : 0 = Système, 1 = Clair, 2 = Sombre
ThemeBloc → ThemeState(themeMode) → ThemeMode.system/light/dark
```

### Typographie

Les polices sont chargées dynamiquement via Google Fonts pour une typographie moderne et personnalisée.

## Gestion des erreurs

### Widgets d'état

L'application dispose de widgets dédiés pour chaque état :

| Widget                  | Usage                                    |
|-------------------------|------------------------------------------|
| `LoadingStateWidget`    | Indicateur de chargement                 |
| `ErrorStateWidget`      | Affichage d'erreur avec bouton réessayer |
| `EmptyStateWidget`      | État vide personnalisable                |
| `NoInternetWidget`      | Pas de connexion internet                |
| `NoSearchResultsWidget` | Aucun résultat de recherche              |

### ErrorHandlerWidget

Widget intelligent qui détecte le type d'erreur (réseau, serveur, générique) et affiche le message approprié.

### SectionErrorWrapper

Wrapper qui encapsule un contenu et affiche un fallback en cas d'erreur, avec une version compacte disponible.

## Services applicatifs

### NotificationService

Service de notifications locales :
- Initialisation avec support des fuseaux horaires
- Programmation de rappels pour les films
- Gestion des permissions (Android/iOS)
- Notifications de test

### LocalizationService

Conversion des locales Flutter vers le format TMDB API :
- `fr` → `fr-FR`
- `en` → `en-US`
- Détection automatique de la langue de l'appareil

### ProviderService

Base de données des fournisseurs de streaming par pays :
- Listes régionales (Netflix, Amazon Prime, Disney+, etc.)
- Support de 18+ pays
- Intégration avec la géolocalisation

## Modèles de données

### Sérialisation JSON

Tous les modèles utilisent des factories `fromJson` pour la désérialisation :

```dart
class PopularMovieModel {
  final int? page;
  final List<MovieResult>? results;
  final int? totalPages;

  factory PopularMovieModel.fromJson(Map<String, dynamic> json) {
    return PopularMovieModel(
      page: json['page'],
      results: (json['results'] as List?)
          ?.map((e) => MovieResult.fromJson(e))
          .toList(),
      totalPages: json['total_pages'],
    );
  }
}
```

### WatchlistItem

Le modèle `WatchlistItem` utilise une désérialisation sécurisée avec validation de types et valeurs par défaut :

```dart
factory WatchlistItem.fromJson(Map<String, dynamic> json) {
  final id = json['id'];
  return WatchlistItem(
    id: id is int ? id : (id is String ? int.tryParse(id) ?? 0 : 0),
    title: title is String ? title : 'Unknown',
    // ...
  );
}
```

### Stockage local

La watchlist est sérialisée en JSON et stockée dans `SharedPreferences` :

```dart
// Sauvegarde
await sharedPreferences.setString('watchlist', jsonEncode(jsonList));

// Lecture (avec gestion d'erreurs)
try {
  final jsonList = jsonDecode(jsonString) as List;
  return jsonList.whereType<Map<String, dynamic>>()
      .map((json) => WatchlistItem.fromJson(json))
      .toList();
} catch (e) {
  return [];
}
```

---

*Ce document est maintenu à jour avec l'évolution de l'architecture de MobMovizz.*
