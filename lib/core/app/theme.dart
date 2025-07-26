import 'package:flutter/material.dart';

class AppTheme {
  // Define your app's color scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2196F3),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF03DAC6),
    onSecondary: Color(0xFF000000),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFF5F5F5),
    onBackground: Color(0xFF000000),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF64B5F6),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF4DD0E1),
    onSecondary: Color(0xFF000000),
    error: Color(0xFFCF6679),
    onError: Color(0xFF000000),
    background: Color(0xFF121212),
    onBackground: Color(0xFFFFFFFF),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFFFFFFF),
  );

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2196F3),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: lightColorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: darkColorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
