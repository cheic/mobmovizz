import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class DateFormatter {
  /// Format a date from API (String or DateTime) to user-friendly format
  static String formatReleaseDate(dynamic dateValue, [BuildContext? context]) {
    if (dateValue == null) return 'Unknown';
    
    try {
      DateTime date;
      
      // Handle both String and DateTime types
      if (dateValue is DateTime) {
        date = dateValue;
      } else if (dateValue is String) {
        if (dateValue.isEmpty) return 'Unknown';
        date = DateTime.parse(dateValue);
      } else {
        return 'Unknown';
      }
      
      // Use French format if context suggests French locale
      final locale = context != null ? Localizations.localeOf(context) : null;
      
      if (locale?.languageCode == 'fr') {
        return DateFormat('dd MMMM yyyy', 'fr').format(date);
      } else {
        return DateFormat('MMM dd, yyyy', 'en').format(date);
      }
    } catch (e) {
      // Handle different date formats for String type
      if (dateValue is String) {
        try {
          // Try parsing as DateTime object toString (for cases where DateTime.toString() was used)
          if (dateValue.contains(' ')) {
            final parts = dateValue.split(' ');
            final datePart = parts[0];
            final date = DateTime.parse(datePart);
            
            final locale = context != null ? Localizations.localeOf(context) : null;
            
            if (locale?.languageCode == 'fr') {
              return DateFormat('dd MMMM yyyy', 'fr').format(date);
            } else {
              return DateFormat('MMM dd, yyyy', 'en').format(date);
            }
          }
        } catch (e) {
          // Date parsing error handled silently
        }
      }
      return 'Unknown';
    }
  }

  /// Format date for display in watchlist reminders
  static String formatReminderDate(DateTime? date) {
    if (date == null) return 'No date';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);
    
    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == today.add(Duration(days: 1))) {
      return 'Tomorrow';
    } else if (dateToCheck.isBefore(today.add(Duration(days: 7)))) {
      return DateFormat('EEEE').format(date); // Day of week
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }

  /// Format date for movie details view
  static String formatDetailDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Not available';
    
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM dd, yyyy').format(date);
    } catch (e) {
      return 'Not available';
    }
  }

  /// Format a DateTime object to user-friendly format with localization
  static String formatDateTime(DateTime? date, [BuildContext? context]) {
    if (date == null) return 'No date set';
    
    try {
      if (context != null) {
        final locale = Localizations.localeOf(context);
        if (locale.languageCode == 'fr') {
          return DateFormat('dd MMMM yyyy', 'fr').format(date);
        }
      }
      return DateFormat('MMM dd, yyyy', 'en').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  /// Format a DateTime object to short date format (MMM dd)
  static String formatShortDate(DateTime? date, [BuildContext? context]) {
    if (date == null) return 'No date';
    
    try {
      if (context != null) {
        final locale = Localizations.localeOf(context);
        if (locale.languageCode == 'fr') {
          return DateFormat('dd MMM', 'fr').format(date);
        }
      }
      return DateFormat('MMM dd', 'en').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  /// Check if a date is in the future (for upcoming movies)
  static bool isUpcoming(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;
    
    try {
      final date = DateTime.parse(dateString);
      return date.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  /// Get days until release
  static int daysUntilRelease(String? dateString) {
    if (dateString == null || dateString.isEmpty) return -1;
    
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final releaseDay = DateTime(date.year, date.month, date.day);
      
      return releaseDay.difference(today).inDays;
    } catch (e) {
      return -1;
    }
  }
}
