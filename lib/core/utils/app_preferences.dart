import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
   final SharedPreferences sharedPreferences;

  AppPreferences(this.sharedPreferences);
  
  static const String _viewModeKey = 'view_mode_grid';
  static const String _themeKey = 'theme_mode';
  static const String _watchlistKey = 'watchlist';

  // Grid View
  Future<void> setGridView(bool isGridView) async {
    await sharedPreferences.setBool(_viewModeKey, isGridView);
  }

  bool getGridView() {
    return sharedPreferences.getBool(_viewModeKey) ?? true;
  }

  // Theme Mode (0: system, 1: light, 2: dark)
  Future<void> setThemeMode(int themeMode) async {
    await sharedPreferences.setInt(_themeKey, themeMode);
  }

  int getThemeMode() {
    return sharedPreferences.getInt(_themeKey) ?? 0; // Default to system
  }

  // Watchlist
  Future<void> saveWatchlist(List<WatchlistItem> watchlist) async {
    final jsonList = watchlist.map((item) => item.toJson()).toList();
    await sharedPreferences.setString(_watchlistKey, jsonEncode(jsonList));
  }

  List<WatchlistItem> getWatchlist() {
    final jsonString = sharedPreferences.getString(_watchlistKey);
    if (jsonString == null) return [];
    
    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .whereType<Map<String, dynamic>>()
          .map((json) => WatchlistItem.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

class WatchlistItem {
  final int id;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final DateTime? reminderDate;
  final bool notifyAgain;
  final DateTime addedDate;

  WatchlistItem({
    required this.id,
    required this.title,
    this.posterPath,
    this.releaseDate,
    this.reminderDate,
    this.notifyAgain = true,
    required this.addedDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'releaseDate': releaseDate,
    'reminderDate': reminderDate?.toIso8601String(),
    'notifyAgain': notifyAgain,
    'addedDate': addedDate.toIso8601String(),
  };

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final addedDate = json['addedDate'];

    return WatchlistItem(
      id: id is int ? id : (id is String ? int.tryParse(id) ?? 0 : 0),
      title: title is String ? title : 'Unknown',
      posterPath: json['posterPath'] as String?,
      releaseDate: json['releaseDate'] as String?,
      reminderDate: json['reminderDate'] != null
          ? DateTime.tryParse(json['reminderDate'].toString())
          : null,
      notifyAgain: json['notifyAgain'] as bool? ?? true,
      addedDate: addedDate != null
          ? (DateTime.tryParse(addedDate.toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}
