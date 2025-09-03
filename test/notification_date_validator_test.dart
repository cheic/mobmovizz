import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobmovizz/core/utils/notification_date_validator.dart';

void main() {
  group('NotificationDateValidator', () {
    test('getMinimumNotificationDate should return today for past release dates', () {
      // Test avec une date de sortie passée
      final pastDate = '2023-01-01';
      final result = NotificationDateValidator.getMinimumNotificationDate(pastDate);
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      
      expect(result, equals(todayOnly));
    });
    
    test('getMinimumNotificationDate should return today for null release date', () {
      final result = NotificationDateValidator.getMinimumNotificationDate(null);
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      
      expect(result, equals(todayOnly));
    });
    
    test('getMinimumNotificationDate should return today for empty release date', () {
      final result = NotificationDateValidator.getMinimumNotificationDate('');
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      
      expect(result, equals(todayOnly));
    });
    
    test('getMinimumNotificationDate should return release date for future releases', () {
      // Test avec une date de sortie future
      final futureDate = DateTime.now().add(Duration(days: 30));
      final futureDateString = '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';
      
      final result = NotificationDateValidator.getMinimumNotificationDate(futureDateString);
      final expectedDate = DateTime(futureDate.year, futureDate.month, futureDate.day);
      
      expect(result, equals(expectedDate));
    });
    
    test('getInitialNotificationDate should return release date for future movies', () {
      final futureDate = DateTime.now().add(Duration(days: 30));
      final futureDateString = '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';
      final time = TimeOfDay(hour: 20, minute: 0);
      
      final result = NotificationDateValidator.getInitialNotificationDate(futureDateString, time);
      final expectedDate = DateTime(futureDate.year, futureDate.month, futureDate.day, 20, 0);
      
      expect(result, equals(expectedDate));
    });
    
    test('getInitialNotificationDate should return tomorrow for past movies', () {
      final pastDate = '2023-01-01';
      final time = TimeOfDay(hour: 20, minute: 0);
      
      final result = NotificationDateValidator.getInitialNotificationDate(pastDate, time);
      final tomorrow = DateTime.now().add(Duration(days: 1));
      final expectedDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 20, 0);
      
      expect(result, equals(expectedDate));
    });
    
    test('isValidNotificationDate should return false for dates before release date', () {
      final futureDate = DateTime.now().add(Duration(days: 30));
      final futureDateString = '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';
      
      // Essayer de programmer une notification avant la date de sortie
      final invalidDate = futureDate.subtract(Duration(days: 1));
      
      final result = NotificationDateValidator.isValidNotificationDate(invalidDate, futureDateString);
      
      expect(result, isFalse);
    });
    
    test('isValidNotificationDate should return true for dates on or after release date', () {
      final futureDate = DateTime.now().add(Duration(days: 30));
      final futureDateString = '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';
      
      // Programmer une notification le jour de sortie
      final validDate = DateTime(futureDate.year, futureDate.month, futureDate.day, 20, 0);
      
      final result = NotificationDateValidator.isValidNotificationDate(validDate, futureDateString);
      
      expect(result, isTrue);
    });
    
    test('getValidationErrorMessage should return appropriate message for future releases', () {
      final futureDate = DateTime.now().add(Duration(days: 30));
      final futureDateString = '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';
      
      final result = NotificationDateValidator.getValidationErrorMessage(futureDateString);
      
      expect(result, contains('${futureDate.day}/${futureDate.month}/${futureDate.year}'));
      expect(result, contains('release date'));
    });
    
    test('getValidationErrorMessage should return generic message for null release date', () {
      final result = NotificationDateValidator.getValidationErrorMessage(null);
      
      expect(result, equals('Notification date cannot be in the past.'));
    });
  });
}
