import 'package:flutter/material.dart';
import 'package:mobmovizz/l10n/app_localizations.dart';

String? formatRuntime(int runtimeInMinutes, [BuildContext? context]) {
  int hours = runtimeInMinutes ~/ 60; 
  int minutes = runtimeInMinutes % 60;

  StringBuffer formattedString = StringBuffer();

  if (context != null) {
    final l10n = AppLocalizations.of(context);
    
    if (hours > 0) {
      formattedString.write('$hours ${l10n?.hours ?? 'hours'}');
    }
    
    if (minutes > 0) {
      if (formattedString.isNotEmpty) {
        formattedString.write(', '); 
      }
      formattedString.write('$minutes ${l10n?.minutes ?? 'minutes'}');
    }
  } else {
    // Fallback to English if no context
    if (hours > 0) {
      formattedString.write('$hours hour${hours > 1 ? 's' : ''}');
    }
    
    if (minutes > 0) {
      if (formattedString.isNotEmpty) {
        formattedString.write(', '); 
      }
      formattedString.write('$minutes minute${minutes > 1 ? 's' : ''}');
    }
  }

  return formattedString.toString();
}
