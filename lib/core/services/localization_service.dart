import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LocalizationService {
  static String getApiLanguage(BuildContext context) {
    final locale = Localizations.localeOf(context);
    
    // Convertir la locale Flutter vers le format TMDB
    switch (locale.languageCode) {
      case 'fr':
        return 'fr-FR';
      case 'en':
      default:
        return 'en-US';
    }
  }
  
  // Nouvelle méthode pour obtenir la langue par défaut sans contexte
  static String getDefaultApiLanguage() {
    final locale = ui.PlatformDispatcher.instance.locale;
    
    switch (locale.languageCode) {
      case 'fr':
        return 'fr-FR';
      case 'en':
      default:
        return 'en-US';
    }
  }
  
  // Méthode unifiée qui essaye d'abord le contexte, puis la locale de l'appareil
  static String getBestAvailableLanguage(BuildContext? context) {
    if (context != null) {
      return getApiLanguage(context);
    }
    return getDefaultApiLanguage();
  }
  
  static String getLanguageCode(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode;
  }
  
  static String getCountryCode(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.countryCode ?? 'US';
  }
}
