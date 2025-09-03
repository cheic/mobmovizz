import 'package:flutter/material.dart';
import 'package:mobmovizz/core/theme/colors.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: royalBlue,
      secondary: royalBlueDerived,
      tertiary: Color(0xFF06B6D4),
      surface: Color(0xFFF8F9FA), // Plus doux que blanc pur
      surfaceContainer: Color(0xFFF1F3F4), // Gris très clair
      surfaceContainerHighest: Color(0xFFE8EAED), // Gris légèrement plus foncé
      onPrimary: snow,
      onSecondary: snow,
      onSurface: Color(0xFF2D3748), // Gris foncé mais pas noir
      onSurfaceVariant: Color(0xFF4A5568), // Gris moyen
      outline: Color(0xFFCBD5E1),
      error: Color(0xFFEF4444),
      onError: snow,
      inverseSurface: surfaceDim,
      onInverseSurface: snow,
    ),
    scaffoldBackgroundColor: Color(0xFFF8F9FA), // Arrière-plan doux
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF8F9FA), // Même couleur que le scaffold
      foregroundColor: Color(0xFF2D3748), // Gris foncé mais pas noir
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Color(0xFF2D3748)),
      actionsIconTheme: IconThemeData(color: Color(0xFF2D3748)),
    ),
    cardTheme: CardThemeData(
      color: Color(0xFFFFFFFF), // Blanc pour les cartes sur fond doux
      elevation: 2,
      shadowColor: Color(0x0A000000), // Ombre très légère
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: royalBlue,
        foregroundColor: snow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: surfaceDim, 
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        color: surfaceDim, 
        fontWeight: FontWeight.w600,
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        color: surfaceDim, 
        fontWeight: FontWeight.w500,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        color: surfaceDim,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: surfaceDim,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: surfaceDim,
        fontSize: 12,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF8F9FA), // Même couleur que le scaffold
      selectedItemColor: royalBlue,
      unselectedItemColor: Color(0xFF4A5568), // Gris moyen
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    iconTheme: IconThemeData(color: surfaceDim),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: royalBlue,
      secondary: royalBlueDerived,
      tertiary: Color(0xFF06B6D4),
      surface: surfaceDim,
      surfaceContainer: Color(0xFF1A1D23),
      surfaceContainerHighest: Color(0xFF212328),
      onPrimary: snow,
      onSecondary: snow,
      onSurface: snow,
      onSurfaceVariant: snow,
      outline: Color(0xFF475569),
      error: Color(0xFFEF4444),
      onError: snow,
      inverseSurface: snow,
      onInverseSurface: surfaceDim,
    ),
    scaffoldBackgroundColor: surfaceDim,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDim,
      foregroundColor: snow,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: snow),
      actionsIconTheme: IconThemeData(color: snow),
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF1A1D23),
      elevation: 8,
      shadowColor: surfaceDim.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: royalBlue,
        foregroundColor: snow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: snow, 
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        color: snow, 
        fontWeight: FontWeight.w600,
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        color: snow, 
        fontWeight: FontWeight.w500,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        color: snow,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: snow,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: snow,
        fontSize: 12,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Color(0xFF475569),
      thickness: 1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDim,
      selectedItemColor: royalBlue,
      unselectedItemColor: snow,
      elevation: 20,
    ),
    iconTheme: IconThemeData(color: snow),
  );

  static ThemeMode getThemeMode(int themeModeValue) {
    switch (themeModeValue) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String getThemeName(int themeModeValue) {
    switch (themeModeValue) {
      case 1:
        return 'Light';
      case 2:
        return 'Dark';
      default:
        return 'System';
    }
  }
}
