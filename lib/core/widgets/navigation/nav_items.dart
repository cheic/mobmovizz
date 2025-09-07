import 'package:flutter/material.dart';
import 'package:mobmovizz/core/widgets/navigation/rive_model.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

List<NavItemModel> getNavItems(BuildContext context) {
  final localizations = AppLocalizations.of(context);
  
  return [
    NavItemModel(
      title: localizations?.home ?? 'Home',
      icon: Icons.home_outlined,
      rive: RiveModel(
        artboard: 'HOME',
        stateMachineName: 'HOME_Interactivity',
        animationName: 'idle',
      ),
    ),
    NavItemModel(
      title: localizations?.genre ?? 'Genre',
      icon: Icons.grid_3x3,
      rive: RiveModel(
        artboard: 'GENRE',
        stateMachineName: 'GENRE_Interactivity',
        animationName: 'idle',
      ),
    ),
    NavItemModel(
      title: localizations?.search ?? 'Search',
      icon: Icons.search_outlined,
      rive: RiveModel(
        artboard: 'SEARCH',
        stateMachineName: 'SEARCH_Interactivity',
        animationName: 'idle',
      ),
    ),
    NavItemModel(
      title: localizations?.favorites ?? 'Watchlist',
      icon: Icons.bookmark_outline,
      rive: RiveModel(
        artboard: 'WATCHLIST',
        stateMachineName: 'WATCHLIST_Interactivity',
        animationName: 'idle',
      ),
    ),
  ];
}

// Garde la liste statique pour la compatibilité, mais avec traductions par défaut
List<NavItemModel> navItems = [
  NavItemModel(
    title: 'Home',
    icon: Icons.home_outlined,
    rive: RiveModel(
      artboard: 'HOME',
      stateMachineName: 'HOME_Interactivity',
      animationName: 'idle',
    ),
  ),
  NavItemModel(
    title: 'Genre',
    icon: Icons.grid_3x3,
    rive: RiveModel(
      artboard: 'GENRE',
      stateMachineName: 'GENRE_Interactivity',
      animationName: 'idle',
    ),
  ),
  NavItemModel(
    title: 'Search',
    icon: Icons.search_outlined,
    rive: RiveModel(
      artboard: 'SEARCH',
      stateMachineName: 'SEARCH_Interactivity',
      animationName: 'idle',
    ),
  ),
  NavItemModel(
    title: 'Watchlist',
    icon: Icons.bookmark_outline,
    rive: RiveModel(
      artboard: 'WATCHLIST',
      stateMachineName: 'WATCHLIST_Interactivity',
      animationName: 'idle',
    ),
  ),
];
