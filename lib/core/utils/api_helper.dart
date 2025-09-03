import 'package:flutter/material.dart';
import 'package:mobmovizz/core/services/localization_service.dart';

class ApiHelper {
  static String? getLanguageFromContext(BuildContext? context) {
    if (context != null) {
      return LocalizationService.getApiLanguage(context);
    }
    return null;
  }
}

/// Extension pour les événements qui ont besoin du contexte pour la localisation
mixin LocalizedEvent {
  BuildContext? get context;
}

/// Interface pour les événements qui nécessitent la localisation
abstract class LocalizationAwareEvent {
  BuildContext? get context;
}
