# 🤝 Guide de Contribution — MobMovizz

Merci de votre intérêt pour contribuer à MobMovizz ! Ce guide vous explique comment participer au développement du projet.

## Table des matières

- [Code de conduite](#code-de-conduite)
- [Comment contribuer](#comment-contribuer)
- [Configuration de l'environnement](#configuration-de-lenvironnement)
- [Conventions de code](#conventions-de-code)
- [Conventions de commit](#conventions-de-commit)
- [Processus de Pull Request](#processus-de-pull-request)
- [Structure d'une fonctionnalité](#structure-dune-fonctionnalité)
- [Tests](#tests)
- [Localisation](#localisation)
- [Signaler un bug](#signaler-un-bug)
- [Proposer une fonctionnalité](#proposer-une-fonctionnalité)

## Code de conduite

- Soyez respectueux et inclusif dans toutes vos interactions
- Donnez et acceptez les retours constructifs avec bienveillance
- Concentrez-vous sur ce qui est le mieux pour le projet et la communauté

## Comment contribuer

### Types de contributions

| Type | Description |
|------|-------------|
| 🐛 **Bug fix** | Correction d'un bug existant |
| ✨ **Feature** | Ajout d'une nouvelle fonctionnalité |
| 📝 **Documentation** | Amélioration de la documentation |
| 🎨 **UI/UX** | Améliorations visuelles ou d'expérience utilisateur |
| ♻️ **Refactoring** | Amélioration du code sans changer le comportement |
| 🧪 **Tests** | Ajout ou amélioration des tests |
| 🌐 **Traduction** | Ajout ou correction de traductions |

### Workflow général

1. **Forkez** le dépôt
2. **Créez** une branche depuis `main`
3. **Développez** votre modification
4. **Testez** vos changements
5. **Committez** avec un message clair
6. **Poussez** vers votre fork
7. **Ouvrez** une Pull Request

## Configuration de l'environnement

Consultez le [guide d'installation](INSTALLATION.md) pour configurer votre environnement de développement.

### Résumé rapide

```bash
# Cloner votre fork
git clone https://github.com/VOTRE_USERNAME/mobmovizz.git
cd mobmovizz

# Ajouter le dépôt original comme remote
git remote add upstream https://github.com/cheic/mobmovizz.git

# Installer les dépendances
flutter pub get

# Créer le fichier de constantes (voir INSTALLATION.md)
# lib/core/utils/constants.dart

# Vérifier que tout fonctionne
flutter test
flutter analyze
```

## Conventions de code

### Style Dart

Le projet utilise les **lints Flutter recommandés** (`flutter_lints`). Respectez les règles définies dans `analysis_options.yaml`.

```bash
# Vérifier le style du code
flutter analyze
```

### Règles générales

- Utilisez les **types explicites** plutôt que `var` ou `dynamic` quand possible
- Préférez les **classes immuables** (`final`, `const`)
- Documentez les classes et méthodes publiques
- Nommez les fichiers en **snake_case**
- Nommez les classes en **PascalCase**
- Nommez les variables et méthodes en **camelCase**

### Structure des fichiers

```dart
// 1. Imports Dart/Flutter
import 'package:flutter/material.dart';

// 2. Imports de packages externes
import 'package:flutter_bloc/flutter_bloc.dart';

// 3. Imports du projet
import 'package:mobmovizz/core/...';

// 4. Définition de la classe
class MaClasse {
  // ...
}
```

### Widgets

- Préférez les `StatelessWidget` quand il n'y a pas d'état local
- Utilisez `const` pour les constructeurs quand possible
- Extrayez les widgets complexes dans des fichiers séparés

## Conventions de commit

Utilisez le format [Conventional Commits](https://www.conventionalcommits.org/fr/) :

```
<type>(<portée>): <description>
```

### Types de commit

| Type | Description |
|------|-------------|
| `feat` | Nouvelle fonctionnalité |
| `fix` | Correction de bug |
| `docs` | Documentation uniquement |
| `style` | Formatage, points-virgules manquants, etc. |
| `refactor` | Refactoring sans changement de comportement |
| `test` | Ajout ou modification de tests |
| `chore` | Maintenance (dépendances, CI, etc.) |
| `perf` | Amélioration des performances |

### Exemples

```bash
feat(search): ajout du filtre par année de sortie
fix(watchlist): correction de la désérialisation JSON
docs(readme): mise à jour du guide d'installation
test(currency): ajout des tests pour le formatage des milliards
refactor(bloc): suppression de BuildContext des events
```

## Processus de Pull Request

### 1. Créer une branche

```bash
# Mettre à jour main
git checkout main
git pull upstream main

# Créer une branche de travail
git checkout -b feat/ma-fonctionnalite
```

### 2. Développer

- Faites des commits atomiques et réguliers
- Gardez les changements focalisés sur un seul sujet
- Testez localement avant de pousser

### 3. Avant de soumettre

```bash
# Vérifier le style
flutter analyze

# Lancer les tests
flutter test

# S'assurer que le build passe
flutter build apk --debug
```

### 4. Soumettre la PR

- Décrivez clairement le **problème** résolu ou la **fonctionnalité** ajoutée
- Référencez l'issue liée si applicable (`Closes #123`)
- Ajoutez des captures d'écran pour les changements visuels
- Listez les changements majeurs

### 5. Revue de code

- Répondez aux commentaires de revue
- Apportez les modifications demandées
- Mettez à jour la PR si nécessaire

## Structure d'une fonctionnalité

Lors de l'ajout d'une nouvelle fonctionnalité, suivez cette structure :

```
lib/features/ma_fonctionnalite/
├── bloc/
│   ├── ma_fonctionnalite_bloc.dart    # Logique métier
│   ├── ma_fonctionnalite_event.dart   # Événements
│   └── ma_fonctionnalite_state.dart   # États
├── data/
│   ├── models/
│   │   └── ma_fonctionnalite_model.dart  # Modèle de données
│   └── service/
│       └── ma_fonctionnalite_service.dart # Service API
└── view/
    └── ma_fonctionnalite_view.dart     # Interface utilisateur
```

### Checklist pour une nouvelle fonctionnalité

- [ ] Créer le modèle de données dans `data/models/`
- [ ] Créer le service API dans `data/service/`
- [ ] Créer les events dans `bloc/`
- [ ] Créer les states dans `bloc/`
- [ ] Créer le BLoC dans `bloc/`
- [ ] Enregistrer le service et le BLoC dans `core/di/injection.dart`
- [ ] Ajouter le BlocProvider dans `main.dart`
- [ ] Créer la vue dans `view/`
- [ ] Ajouter les traductions dans `l10n/app_en.arb` et `l10n/app_fr.arb`
- [ ] Écrire des tests unitaires
- [ ] Tester sur émulateur

## Tests

### Types de tests

| Type | Emplacement | Commande |
|------|-------------|----------|
| **Unitaires** | `test/` | `flutter test` |
| **Widgets** | `test/` | `flutter test` |

### Écrire un test

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MaFonctionnalité', () {
    test('devrait faire X quand Y', () {
      // Arrange
      final input = ...;

      // Act
      final result = maFonction(input);

      // Assert
      expect(result, expectedValue);
    });
  });
}
```

### Conventions de test

- Nommez les fichiers `*_test.dart`
- Utilisez `group()` pour organiser les tests par fonctionnalité
- Utilisez des descriptions en français ou en anglais (soyez cohérent)
- Suivez le pattern **Arrange-Act-Assert**

## Localisation

### Ajouter une traduction

1. **Ajoutez la clé** dans `lib/l10n/app_en.arb` (fichier template) :

```json
{
  "maCle": "My translation",
  "@maCle": {
    "description": "Description de l'usage"
  }
}
```

2. **Ajoutez la traduction française** dans `lib/l10n/app_fr.arb` :

```json
{
  "maCle": "Ma traduction"
}
```

3. **Régénérez les fichiers** :

```bash
flutter gen-l10n
```

4. **Utilisez dans le code** :

```dart
AppLocalizations.of(context)!.maCle
```

### Règles de traduction

- Toutes les chaînes visibles par l'utilisateur doivent être localisées
- Ne codez jamais de texte en dur dans les widgets
- Utilisez des descriptions `@` pour aider les traducteurs

## Signaler un bug

Ouvrez une **issue** sur GitHub avec les informations suivantes :

1. **Description** du bug
2. **Étapes pour reproduire** le problème
3. **Comportement attendu** vs **comportement observé**
4. **Environnement** :
   - Version de Flutter (`flutter --version`)
   - Appareil / Émulateur
   - Système d'exploitation
5. **Captures d'écran** si pertinent
6. **Logs d'erreur** si disponibles

## Proposer une fonctionnalité

Ouvrez une **issue** avec le label `enhancement` :

1. **Description** de la fonctionnalité
2. **Motivation** — Pourquoi cette fonctionnalité est-elle utile ?
3. **Proposition technique** — Comment pourrait-elle être implémentée ?
4. **Maquettes** ou wireframes si applicable

---

*Merci de contribuer à MobMovizz ! Chaque contribution, aussi petite soit-elle, fait la différence. 🎬*
# 🤝 Guide de Contribution — MobMovizz

Merci de votre intérêt pour contribuer à MobMovizz ! Ce guide vous explique comment participer au développement du projet.

## Table des matières

- [Code de conduite](#code-de-conduite)
- [Comment contribuer](#comment-contribuer)
- [Configuration de l'environnement](#configuration-de-lenvironnement)
- [Conventions de code](#conventions-de-code)
- [Conventions de commit](#conventions-de-commit)
- [Processus de Pull Request](#processus-de-pull-request)
- [Structure d'une fonctionnalité](#structure-dune-fonctionnalité)
- [Tests](#tests)
- [Localisation](#localisation)
- [Signaler un bug](#signaler-un-bug)
- [Proposer une fonctionnalité](#proposer-une-fonctionnalité)

## Code de conduite

- Soyez respectueux et inclusif dans toutes vos interactions
- Donnez et acceptez les retours constructifs avec bienveillance
- Concentrez-vous sur ce qui est le mieux pour le projet et la communauté

## Comment contribuer

### Types de contributions

| Type | Description |
|------|-------------|
| 🐛 **Bug fix** | Correction d'un bug existant |
| ✨ **Feature** | Ajout d'une nouvelle fonctionnalité |
| 📝 **Documentation** | Amélioration de la documentation |
| 🎨 **UI/UX** | Améliorations visuelles ou d'expérience utilisateur |
| ♻️ **Refactoring** | Amélioration du code sans changer le comportement |
| 🧪 **Tests** | Ajout ou amélioration des tests |
| 🌐 **Traduction** | Ajout ou correction de traductions |

### Workflow général

1. **Forkez** le dépôt
2. **Créez** une branche depuis `main`
3. **Développez** votre modification
4. **Testez** vos changements
5. **Committez** avec un message clair
6. **Poussez** vers votre fork
7. **Ouvrez** une Pull Request

## Configuration de l'environnement

Consultez le [guide d'installation](INSTALLATION.md) pour configurer votre environnement de développement.

### Résumé rapide

```bash
# Cloner votre fork
git clone https://github.com/VOTRE_USERNAME/mobmovizz.git
cd mobmovizz

# Ajouter le dépôt original comme remote
git remote add upstream https://github.com/cheic/mobmovizz.git

# Installer les dépendances
flutter pub get

# Créer le fichier de constantes (voir INSTALLATION.md)
# lib/core/utils/constants.dart

# Vérifier que tout fonctionne
flutter test
flutter analyze
```

## Conventions de code

### Style Dart

Le projet utilise les **lints Flutter recommandés** (`flutter_lints`). Respectez les règles définies dans `analysis_options.yaml`.

```bash
# Vérifier le style du code
flutter analyze
```

### Règles générales

- Utilisez les **types explicites** plutôt que `var` ou `dynamic` quand possible
- Préférez les **classes immuables** (`final`, `const`)
- Documentez les classes et méthodes publiques
- Nommez les fichiers en **snake_case**
- Nommez les classes en **PascalCase**
- Nommez les variables et méthodes en **camelCase**

### Structure des fichiers

```dart
// 1. Imports Dart/Flutter
import 'package:flutter/material.dart';

// 2. Imports de packages externes
import 'package:flutter_bloc/flutter_bloc.dart';

// 3. Imports du projet
import 'package:mobmovizz/core/...';

// 4. Définition de la classe
class MaClasse {
  // ...
}
```

### Widgets

- Préférez les `StatelessWidget` quand il n'y a pas d'état local
- Utilisez `const` pour les constructeurs quand possible
- Extrayez les widgets complexes dans des fichiers séparés

## Conventions de commit

Utilisez le format [Conventional Commits](https://www.conventionalcommits.org/fr/) :

```
<type>(<portée>): <description>
```

### Types de commit

| Type | Description |
|------|-------------|
| `feat` | Nouvelle fonctionnalité |
| `fix` | Correction de bug |
| `docs` | Documentation uniquement |
| `style` | Formatage, points-virgules manquants, etc. |
| `refactor` | Refactoring sans changement de comportement |
| `test` | Ajout ou modification de tests |
| `chore` | Maintenance (dépendances, CI, etc.) |
| `perf` | Amélioration des performances |

### Exemples

```bash
feat(search): ajout du filtre par année de sortie
fix(watchlist): correction de la désérialisation JSON
docs(readme): mise à jour du guide d'installation
test(currency): ajout des tests pour le formatage des milliards
refactor(bloc): suppression de BuildContext des events
```

## Processus de Pull Request

### 1. Créer une branche

```bash
# Mettre à jour main
git checkout main
git pull upstream main

# Créer une branche de travail
git checkout -b feat/ma-fonctionnalite
```

### 2. Développer

- Faites des commits atomiques et réguliers
- Gardez les changements focalisés sur un seul sujet
- Testez localement avant de pousser

### 3. Avant de soumettre

```bash
# Vérifier le style
flutter analyze

# Lancer les tests
flutter test

# S'assurer que le build passe
flutter build appbundle --debug
```

### 4. Soumettre la PR

- Décrivez clairement le **problème** résolu ou la **fonctionnalité** ajoutée
- Référencez l'issue liée si applicable (`Closes #123`)
- Ajoutez des captures d'écran pour les changements visuels
- Listez les changements majeurs

### 5. Revue de code

- Répondez aux commentaires de revue
- Apportez les modifications demandées
- Mettez à jour la PR si nécessaire

## Structure d'une fonctionnalité

Lors de l'ajout d'une nouvelle fonctionnalité, suivez cette structure :

```
lib/features/ma_fonctionnalite/
├── bloc/
│   ├── ma_fonctionnalite_bloc.dart    # Logique métier
│   ├── ma_fonctionnalite_event.dart   # Événements
│   └── ma_fonctionnalite_state.dart   # États
├── data/
│   ├── models/
│   │   └── ma_fonctionnalite_model.dart  # Modèle de données
│   └── service/
│       └── ma_fonctionnalite_service.dart # Service API
└── view/
    └── ma_fonctionnalite_view.dart     # Interface utilisateur
```

### Checklist pour une nouvelle fonctionnalité

- [ ] Créer le modèle de données dans `data/models/`
- [ ] Créer le service API dans `data/service/`
- [ ] Créer les events dans `bloc/`
- [ ] Créer les states dans `bloc/`
- [ ] Créer le BLoC dans `bloc/`
- [ ] Enregistrer le service et le BLoC dans `core/di/injection.dart`
- [ ] Ajouter le BlocProvider dans `main.dart`
- [ ] Créer la vue dans `view/`
- [ ] Ajouter les traductions dans `l10n/app_en.arb` et `l10n/app_fr.arb`
- [ ] Écrire des tests unitaires
- [ ] Tester sur émulateur

## Tests

### Types de tests

| Type | Emplacement | Commande |
|------|-------------|----------|
| **Unitaires** | `test/` | `flutter test` |
| **Widgets** | `test/` | `flutter test` |

### Écrire un test

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MaFonctionnalité', () {
    test('devrait faire X quand Y', () {
      // Arrange
      final input = ...;

      // Act
      final result = maFonction(input);

      // Assert
      expect(result, expectedValue);
    });
  });
}
```

### Conventions de test

- Nommez les fichiers `*_test.dart`
- Utilisez `group()` pour organiser les tests par fonctionnalité
- Utilisez des descriptions en français ou en anglais (soyez cohérent)
- Suivez le pattern **Arrange-Act-Assert**

## Localisation

### Ajouter une traduction

1. **Ajoutez la clé** dans `lib/l10n/app_en.arb` (fichier template) :

```json
{
  "maCle": "My translation",
  "@maCle": {
    "description": "Description de l'usage"
  }
}
```

2. **Ajoutez la traduction française** dans `lib/l10n/app_fr.arb` :

```json
{
  "maCle": "Ma traduction"
}
```

3. **Régénérez les fichiers** :

```bash
flutter gen-l10n
```

4. **Utilisez dans le code** :

```dart
AppLocalizations.of(context)!.maCle
```

### Règles de traduction

- Toutes les chaînes visibles par l'utilisateur doivent être localisées
- Ne codez jamais de texte en dur dans les widgets
- Utilisez des descriptions `@` pour aider les traducteurs

## Signaler un bug

Ouvrez une **issue** sur GitHub avec les informations suivantes :

1. **Description** du bug
2. **Étapes pour reproduire** le problème
3. **Comportement attendu** vs **comportement observé**
4. **Environnement** :
   - Version de Flutter (`flutter --version`)
   - Appareil / Émulateur
   - Système d'exploitation
5. **Captures d'écran** si pertinent
6. **Logs d'erreur** si disponibles

## Proposer une fonctionnalité

Ouvrez une **issue** avec le label `enhancement` :

1. **Description** de la fonctionnalité
2. **Motivation** — Pourquoi cette fonctionnalité est-elle utile ?
3. **Proposition technique** — Comment pourrait-elle être implémentée ?
4. **Maquettes** ou wireframes si applicable

---

*Merci de contribuer à MobMovizz ! Chaque contribution, aussi petite soit-elle, fait la différence. 🎬*
