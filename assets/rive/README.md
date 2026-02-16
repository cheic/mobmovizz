# Animations Rive de la barre de navigation

Ce dossier est destiné à contenir les fichiers d'animation Rive (.riv) pour la barre de navigation.

## Fichiers requis (optionnels)

- `home_icon.riv` - Animation pour l'onglet Home
- `genre_icon.riv` - Animation pour l'onglet Genre  
- `search_icon.riv` - Animation pour l'onglet Search
- `watchlist_icon.riv` - Animation pour l'onglet Watchlist

## Fallback

Si ces fichiers ne sont pas présents, l'application utilisera automatiquement des icônes Material Icons standard. Les animations Rive sont donc **optionnelles**.

## Créer les animations

Pour créer ces animations, utilisez [Rive Editor](https://rive.app/) et assurez-vous que chaque fichier contient :
- Un artboard nommé selon la convention (HOME, GENRE, SEARCH, WATCHLIST)
- Une state machine nommée `{NAME}_Interactivity`
- Un input booléen nommé `active`
