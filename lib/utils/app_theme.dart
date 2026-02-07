import 'package:flutter/material.dart';

class AppTheme {
  // ==================== CORE THEMES ====================

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF2575FC),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2575FC),
      primaryContainer: Color(0xFFD6E4FF),
      secondary: Color(0xFF6A11CB),
      secondaryContainer: Color(0xFFE8D6FF),
      surface: Colors.white,
      background: Color(0xFFF5F5F7),
      error: Color(0xFFD32F2F),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
      surfaceVariant: Color(0xFFF0F0F0),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F7),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2575FC),
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2575FC),
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF2575FC),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2575FC),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF2575FC), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2575FC), width: 2),
      ),
      contentPadding: const EdgeInsets.all(20),
      hintStyle: const TextStyle(color: Colors.grey),
      labelStyle: const TextStyle(color: Colors.black54),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        fontFamily: 'Inter',
        color: Colors.black87,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
        color: Colors.black87,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
        color: Colors.black87,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
        color: Colors.black87,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        color: Colors.black87,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        color: Colors.black54,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black54),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
      space: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFE8F0FE),
      disabledColor: Colors.grey[300],
      selectedColor: const Color(0xFF2575FC),
      secondarySelectedColor: const Color(0xFF2575FC),
      labelStyle: const TextStyle(color: Colors.black87),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      brightness: Brightness.light,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueAccent,
    colorScheme: const ColorScheme.dark(
      primary: Colors.blueAccent,
      primaryContainer: Color(0xFF1E3A5F),
      secondary: Colors.cyanAccent,
      secondaryContainer: Color(0xFF004346),
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: Color(0xFFCF6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      surfaceVariant: Color(0xFF2D2D2D),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blueAccent,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blueAccent, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2D2D2D)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.all(20),
      hintStyle: const TextStyle(color: Colors.grey),
      labelStyle: const TextStyle(color: Colors.grey),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        fontFamily: 'Inter',
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        color: Colors.grey,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2D2D2D),
      thickness: 1,
      space: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2D2D2D),
      disabledColor: Colors.grey[700],
      selectedColor: Colors.blueAccent,
      secondarySelectedColor: Colors.blueAccent,
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      brightness: Brightness.dark,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // ==================== SPECIAL THEMES ====================

  // Blue Dark Theme (Professional Dark Blue)
  static final ThemeData blueDarkTheme = darkTheme.copyWith(
    colorScheme: darkTheme.colorScheme.copyWith(
      primary: const Color(0xFF64B5F6),
      primaryContainer: const Color(0xFF0D47A1),
      secondary: const Color(0xFF4FC3F7),
      secondaryContainer: const Color(0xFF01579B),
      surface: const Color(0xFF0A1A2F),
      background: const Color(0xFF0A1A2F),
      surfaceVariant: const Color(0xFF1A2F4F),
    ),
    scaffoldBackgroundColor: const Color(0xFF0A1A2F),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A2F4F),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    appBarTheme: darkTheme.appBarTheme.copyWith(
      backgroundColor: const Color(0xFF0D47A1),
    ),
    floatingActionButtonTheme: darkTheme.floatingActionButtonTheme.copyWith(
      backgroundColor: const Color(0xFF64B5F6),
    ),
  );

  // Sunset Theme (Warm Orange/Yellow)
  static final ThemeData sunsetTheme = lightTheme.copyWith(
    colorScheme: lightTheme.colorScheme.copyWith(
      primary: const Color(0xFFFF9800),
      primaryContainer: const Color(0xFFFFE0B2),
      secondary: const Color(0xFFFF5722),
      secondaryContainer: const Color(0xFFFFCCBC),
      surface: const Color(0xFFFFF3E0),
      background: const Color(0xFFFFF3E0),
      surfaceVariant: const Color(0xFFFFE0B2),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF3E0),
    cardTheme: CardThemeData(
      color: const Color(0xFFFFE0B2),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    appBarTheme: lightTheme.appBarTheme.copyWith(
      backgroundColor: const Color(0xFFFF9800),
    ),
    floatingActionButtonTheme: lightTheme.floatingActionButtonTheme.copyWith(
      backgroundColor: const Color(0xFFFF9800),
    ),
    textTheme: lightTheme.textTheme.apply(
      bodyColor: const Color(0xFF5D4037),
      displayColor: const Color(0xFF5D4037),
    ),
  );

  // Forest Theme (Green Nature Theme)
  static final ThemeData forestTheme = lightTheme.copyWith(
    colorScheme: lightTheme.colorScheme.copyWith(
      primary: const Color(0xFF4CAF50),
      primaryContainer: const Color(0xFFC8E6C9),
      secondary: const Color(0xFF388E3C),
      secondaryContainer: const Color(0xFFA5D6A7),
      surface: const Color(0xFFE8F5E9),
      background: const Color(0xFFE8F5E9),
      surfaceVariant: const Color(0xFFC8E6C9),
    ),
    scaffoldBackgroundColor: const Color(0xFFE8F5E9),
    cardTheme: CardThemeData(
      color: const Color(0xFFC8E6C9),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    appBarTheme: lightTheme.appBarTheme.copyWith(
      backgroundColor: const Color(0xFF4CAF50),
    ),
    floatingActionButtonTheme: lightTheme.floatingActionButtonTheme.copyWith(
      backgroundColor: const Color(0xFF4CAF50),
    ),
    textTheme: lightTheme.textTheme.apply(
      bodyColor: const Color(0xFF1B5E20),
      displayColor: const Color(0xFF1B5E20),
    ),
  );

  // Midnight Theme (Deep Purple/Indigo)
  static final ThemeData midnightTheme = darkTheme.copyWith(
    colorScheme: darkTheme.colorScheme.copyWith(
      primary: const Color(0xFF9575CD),
      primaryContainer: const Color(0xFF512DA8),
      secondary: const Color(0xFF7E57C2),
      secondaryContainer: const Color(0xFF4527A0),
      surface: const Color(0xFF1A1A2E),
      background: const Color(0xFF1A1A2E),
      surfaceVariant: const Color(0xFF16213E),
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A2E),
    cardTheme: CardThemeData(
      color: const Color(0xFF16213E),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    appBarTheme: darkTheme.appBarTheme.copyWith(
      backgroundColor: const Color(0xFF512DA8),
    ),
    floatingActionButtonTheme: darkTheme.floatingActionButtonTheme.copyWith(
      backgroundColor: const Color(0xFF9575CD),
    ),
  );

  // High Contrast Theme (Accessibility)
  static final ThemeData highContrastTheme = lightTheme.copyWith(
    colorScheme: lightTheme.colorScheme.copyWith(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.black,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      background: Colors.white,
      onBackground: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        fontFamily: 'Inter',
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        fontFamily: 'Inter',
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        fontFamily: 'Inter',
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        fontFamily: 'Inter',
        color: Colors.black,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        fontFamily: 'Inter',
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        fontFamily: 'Inter',
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
        color: Colors.black,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    dividerTheme: const DividerThemeData(
      color: Colors.black,
      thickness: 2,
      space: 0,
    ),
  );

  // ==================== THEME GETTERS ====================

  // Get theme by name
  static ThemeData getTheme(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'light':
        return lightTheme;
      case 'dark':
        return darkTheme;
      case 'blue_dark':
        return blueDarkTheme;
      case 'sunset':
        return sunsetTheme;
      case 'forest':
        return forestTheme;
      case 'midnight':
        return midnightTheme;
      case 'high_contrast':
        return highContrastTheme;
      default:
        return lightTheme;
    }
  }

  // Get theme preview color
  static Color getThemePreviewColor(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'light':
        return const Color(0xFFF5F5F7);
      case 'dark':
        return const Color(0xFF121212);
      case 'blue_dark':
        return const Color(0xFF0A1A2F);
      case 'sunset':
        return const Color(0xFFFFF3E0);
      case 'forest':
        return const Color(0xFFE8F5E9);
      case 'midnight':
        return const Color(0xFF1A1A2E);
      case 'high_contrast':
        return Colors.white;
      default:
        return const Color(0xFFF5F5F7);
    }
  }

  // Get theme accent color
  static Color getThemeAccentColor(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'light':
        return const Color(0xFF2575FC);
      case 'dark':
        return Colors.blueAccent;
      case 'blue_dark':
        return const Color(0xFF64B5F6);
      case 'sunset':
        return const Color(0xFFFF9800);
      case 'forest':
        return const Color(0xFF4CAF50);
      case 'midnight':
        return const Color(0xFF9575CD);
      case 'high_contrast':
        return Colors.black;
      default:
        return const Color(0xFF2575FC);
    }
  }

  // Check if theme is dark
  static bool isDarkTheme(String themeName) {
    final darkThemes = ['dark', 'blue_dark', 'midnight'];
    return darkThemes.contains(themeName.toLowerCase());
  }

  // Get all available theme names
  static List<String> getAvailableThemes() {
    return [
      'light',
      'dark',
      'blue_dark',
      'sunset',
      'forest',
      'midnight',
      'high_contrast',
    ];
  }

  // Get theme display name
  static String getThemeDisplayName(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'blue_dark':
        return 'Blue Dark';
      case 'sunset':
        return 'Sunset';
      case 'forest':
        return 'Forest';
      case 'midnight':
        return 'Midnight';
      case 'high_contrast':
        return 'High Contrast';
      default:
        return 'Light';
    }
  }
}
