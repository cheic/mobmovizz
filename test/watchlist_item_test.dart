import 'package:flutter_test/flutter_test.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';

void main() {
  group('WatchlistItem.fromJson', () {
    test('should parse valid JSON correctly', () {
      final json = {
        'id': 123,
        'title': 'Test Movie',
        'posterPath': '/poster.jpg',
        'releaseDate': '2025-06-15',
        'reminderDate': '2025-06-15T20:00:00.000',
        'notifyAgain': false,
        'addedDate': '2025-01-01T10:00:00.000',
      };

      final item = WatchlistItem.fromJson(json);

      expect(item.id, 123);
      expect(item.title, 'Test Movie');
      expect(item.posterPath, '/poster.jpg');
      expect(item.releaseDate, '2025-06-15');
      expect(item.reminderDate, isNotNull);
      expect(item.notifyAgain, false);
      expect(item.addedDate.year, 2025);
    });

    test('should handle missing id gracefully', () {
      final json = {
        'title': 'Test Movie',
        'addedDate': '2025-01-01T10:00:00.000',
      };

      final item = WatchlistItem.fromJson(json);

      expect(item.id, 0);
    });

    test('should handle missing title gracefully', () {
      final json = {
        'id': 1,
        'addedDate': '2025-01-01T10:00:00.000',
      };

      final item = WatchlistItem.fromJson(json);

      expect(item.title, 'Unknown');
    });

    test('should handle missing addedDate with fallback to now', () {
      final json = {
        'id': 1,
        'title': 'Test Movie',
      };

      final before = DateTime.now();
      final item = WatchlistItem.fromJson(json);
      final after = DateTime.now();

      expect(item.addedDate.isAfter(before.subtract(const Duration(seconds: 1))), true);
      expect(item.addedDate.isBefore(after.add(const Duration(seconds: 1))), true);
    });

    test('should handle invalid addedDate with fallback to now', () {
      final json = {
        'id': 1,
        'title': 'Test Movie',
        'addedDate': 'not-a-date',
      };

      final before = DateTime.now();
      final item = WatchlistItem.fromJson(json);
      final after = DateTime.now();

      expect(item.addedDate.isAfter(before.subtract(const Duration(seconds: 1))), true);
      expect(item.addedDate.isBefore(after.add(const Duration(seconds: 1))), true);
    });

    test('should handle null reminderDate', () {
      final json = {
        'id': 1,
        'title': 'Test Movie',
        'reminderDate': null,
        'addedDate': '2025-01-01T10:00:00.000',
      };

      final item = WatchlistItem.fromJson(json);

      expect(item.reminderDate, isNull);
    });

    test('should handle invalid reminderDate gracefully', () {
      final json = {
        'id': 1,
        'title': 'Test Movie',
        'reminderDate': 'invalid-date',
        'addedDate': '2025-01-01T10:00:00.000',
      };

      final item = WatchlistItem.fromJson(json);

      expect(item.reminderDate, isNull);
    });

    test('should default notifyAgain to true when missing', () {
      final json = {
        'id': 1,
        'title': 'Test Movie',
        'addedDate': '2025-01-01T10:00:00.000',
      };

      final item = WatchlistItem.fromJson(json);

      expect(item.notifyAgain, true);
    });

    test('should handle string id by parsing it', () {
      final json = {
        'id': '456',
        'title': 'Test Movie',
        'addedDate': '2025-01-01T10:00:00.000',
      };

      final item = WatchlistItem.fromJson(json);

      expect(item.id, 456);
    });

    test('should handle non-parseable string id with fallback to 0', () {
      final json = {
        'id': 'abc',
        'title': 'Test Movie',
        'addedDate': '2025-01-01T10:00:00.000',
      };

      final item = WatchlistItem.fromJson(json);

      expect(item.id, 0);
    });

    test('toJson and fromJson roundtrip should preserve data', () {
      final original = WatchlistItem(
        id: 42,
        title: 'Round Trip Movie',
        posterPath: '/poster.jpg',
        releaseDate: '2025-12-25',
        reminderDate: DateTime(2025, 12, 25, 20, 0),
        notifyAgain: true,
        addedDate: DateTime(2025, 1, 1, 10, 0),
      );

      final json = original.toJson();
      final restored = WatchlistItem.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.posterPath, original.posterPath);
      expect(restored.releaseDate, original.releaseDate);
      expect(restored.notifyAgain, original.notifyAgain);
    });
  });
}
