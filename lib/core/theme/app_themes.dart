import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobmovizz/core/theme/colors.dart';

class AppThemes {
  // ── Typography ────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color base, Color muted) {
    return GoogleFonts.plusJakartaSansTextTheme(TextTheme(
      headlineLarge: TextStyle(color: base, fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: -0.5),
      headlineMedium: TextStyle(color: base, fontWeight: FontWeight.w700, fontSize: 26, letterSpacing: -0.3),
      headlineSmall: TextStyle(color: base, fontWeight: FontWeight.w600, fontSize: 22),
      titleLarge: TextStyle(color: base, fontWeight: FontWeight.w700, fontSize: 20),
      titleMedium: TextStyle(color: base, fontWeight: FontWeight.w600, fontSize: 16),
      titleSmall: TextStyle(color: muted, fontWeight: FontWeight.w500, fontSize: 14),
      bodyLarge: TextStyle(color: base, fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(color: muted, fontSize: 14, height: 1.5),
      bodySmall: TextStyle(color: muted, fontSize: 12, height: 1.4),
      labelLarge: TextStyle(color: base, fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.5),
      labelMedium: TextStyle(color: muted, fontWeight: FontWeight.w500, fontSize: 12),
      labelSmall: TextStyle(color: muted, fontWeight: FontWeight.w500, fontSize: 11, letterSpacing: 0.5),
    ));
  }

  // ── Light Theme ───────────────────────────────────────────────
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: royalBlue,
      secondary: royalBlueDerived,
      tertiary: accentAmber,
      surface: Color(0xFFF6F8FA),
      surfaceContainer: Colors.white,
      surfaceContainerHighest: Color(0xFFEEF1F5),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1D21),
      onSurfaceVariant: Color(0xFF4A5568),
      outline: Color(0xFFD0D7DE),
      outlineVariant: Color(0xFFE8ECF0),
      error: Color(0xFFDC3545),
      onError: Colors.white,
      inverseSurface: surfaceDim,
      onInverseSurface: snow,
    ),
    scaffoldBackgroundColor: Color(0xFFF6F8FA),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1A1D21),
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: Color(0xFF1A1D21),
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Color(0xFF1A1D21)),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Color(0xFFE8ECF0), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: royalBlue,
        textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFFE2E6ED),
      labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, fontSize: 13, color: Color(0xFF1F2937)),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFFD0D7DE), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: royalBlue, width: 2),
      ),
      hintStyle: GoogleFonts.plusJakartaSans(color: Color(0xFF8B95A5), fontSize: 15),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: royalBlue,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      surfaceTintColor: Colors.transparent,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      indicatorColor: royalBlue.withValues(alpha: 0.12),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: royalBlue, size: 24);
        }
        return IconThemeData(color: Color(0xFF8B95A5), size: 24);
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    dividerTheme: DividerThemeData(color: Color(0xFFE8ECF0), thickness: 1),
    textTheme: _buildTextTheme(Color(0xFF1A1D21), Color(0xFF4A5568)),
    iconTheme: IconThemeData(color: Color(0xFF1A1D21)),
  );

  // ── Dark Theme ────────────────────────────────────────────────
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: royalBlueDerived,
      secondary: royalBlueDerived,
      tertiary: accentAmber,
      surface: surfaceDim,
      surfaceContainer: surfaceDimLight,
      surfaceContainerHighest: Color(0xFF21262D),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFE6EDF3),
      onSurfaceVariant: Color(0xFF8B949E),
      outline: Color(0xFF30363D),
      outlineVariant: Color(0xFF21262D),
      error: Color(0xFFF85149),
      onError: Colors.white,
      inverseSurface: snow,
      onInverseSurface: surfaceDim,
    ),
    scaffoldBackgroundColor: surfaceDim,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDim,
      foregroundColor: Color(0xFFE6EDF3),
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: Color(0xFFE6EDF3),
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Color(0xFFE6EDF3)),
    ),
    cardTheme: CardThemeData(
      color: surfaceDimLight,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Color(0xFF30363D), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: royalBlueDerived,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: royalBlueDerived,
        textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF21262D),
      labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, fontSize: 13, color: Color(0xFFE6EDF3)),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDimLight,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFF30363D), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: royalBlueDerived, width: 2),
      ),
      hintStyle: GoogleFonts.plusJakartaSans(color: Color(0xFF8B949E), fontSize: 15),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: royalBlueDerived,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: surfaceDimLight,
      surfaceTintColor: Colors.transparent,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceDimLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceDim,
      elevation: 0,
      indicatorColor: royalBlueDerived.withValues(alpha: 0.15),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: royalBlueDerived, size: 24);
        }
        return IconThemeData(color: Color(0xFF8B949E), size: 24);
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    dividerTheme: DividerThemeData(color: Color(0xFF30363D), thickness: 1),
    textTheme: _buildTextTheme(Color(0xFFE6EDF3), Color(0xFF8B949E)),
    iconTheme: IconThemeData(color: Color(0xFFE6EDF3)),
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
