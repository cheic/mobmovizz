import 'package:flutter/material.dart';

class NotificationDateValidator {
  /// Returns the minimum date from which notifications can be scheduled for a movie
  /// 
  /// Rules:
  /// - If the movie has a release date in the future, notifications can only start from that date
  /// - If the movie has already been released or no release date, notifications can start from today
  /// - Always ensures the minimum date is not in the past
  static DateTime getMinimumNotificationDate(String? releaseDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // If no release date provided, allow notifications from today
    if (releaseDate == null || releaseDate.isEmpty) {
      return today;
    }
    
    try {
      final parsedReleaseDate = DateTime.parse(releaseDate);
      final releaseDateOnly = DateTime(
        parsedReleaseDate.year, 
        parsedReleaseDate.month, 
        parsedReleaseDate.day
      );
      
      // If the movie is already released or releases today, allow notifications from today
      if (releaseDateOnly.isBefore(today) || releaseDateOnly.isAtSameMomentAs(today)) {
        return today;
      }
      
      // If the movie releases in the future, notifications can only start from release date
      return releaseDateOnly;
      
    } catch (e) {
      // If we can't parse the release date, fallback to today
      return today;
    }
  }
  
  /// Returns the initial suggested notification date for a movie
  /// 
  /// Rules:
  /// - If the movie releases in the future, suggest the exact release date
  /// - If the movie is already released, suggest tomorrow
  /// - If no release date, suggest tomorrow
  static DateTime getInitialNotificationDate(String? releaseDate, TimeOfDay time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // If no release date provided, suggest tomorrow
    if (releaseDate == null || releaseDate.isEmpty) {
      final tomorrow = now.add(Duration(days: 1));
      return DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        time.hour,
        time.minute,
      );
    }
    
    try {
      final parsedReleaseDate = DateTime.parse(releaseDate);
      final releaseDateOnly = DateTime(
        parsedReleaseDate.year, 
        parsedReleaseDate.month, 
        parsedReleaseDate.day
      );
      
      // If the movie releases in the future, use the exact release date
      if (releaseDateOnly.isAfter(today)) {
        return DateTime(
          releaseDateOnly.year,
          releaseDateOnly.month,
          releaseDateOnly.day,
          time.hour,
          time.minute,
        );
      }
      
      // If the movie is already released or releases today, suggest tomorrow or later today
      DateTime initialDate = DateTime(
        today.year,
        today.month,
        today.day,
        time.hour,
        time.minute,
      );
      
      // If the suggested time today is in the past, move to tomorrow
      if (initialDate.isBefore(now)) {
        final tomorrow = now.add(Duration(days: 1));
        initialDate = DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
          time.hour,
          time.minute,
        );
      }
      
      return initialDate;
      
    } catch (e) {
      // If we can't parse the release date, suggest tomorrow
      final tomorrow = now.add(Duration(days: 1));
      return DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        time.hour,
        time.minute,
      );
    }
  }
  
  /// Validates if a notification date is valid for a movie
  /// Returns true if the date is valid, false otherwise
  static bool isValidNotificationDate(DateTime notificationDate, String? releaseDate) {
    final minimumDate = getMinimumNotificationDate(releaseDate);
    final notificationDateOnly = DateTime(
      notificationDate.year,
      notificationDate.month,
      notificationDate.day,
    );
    
    return notificationDateOnly.isAfter(minimumDate) || 
           notificationDateOnly.isAtSameMomentAs(minimumDate);
  }
  
  /// Gets a user-friendly error message when notification date is invalid
  static String getValidationErrorMessage(String? releaseDate) {
    if (releaseDate == null || releaseDate.isEmpty) {
      return 'Notification date cannot be in the past.';
    }
    
    try {
      final parsedReleaseDate = DateTime.parse(releaseDate);
      final releaseDateFormatted = '${parsedReleaseDate.day}/${parsedReleaseDate.month}/${parsedReleaseDate.year}';
      return 'Notifications for this movie can only be scheduled from its release date ($releaseDateFormatted) onwards.';
    } catch (e) {
      return 'Notification date cannot be in the past.';
    }
  }
}
