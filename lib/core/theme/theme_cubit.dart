// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(isDarkMode: false));

  // ============================================================================
  // 🎨 APP COLORS (MOVED INSIDE THEME CUBIT)
  // ============================================================================

  // ------------------- BRAND COLORS -------------------
  static const Color brandPrimary = Color(0xFF005BEA);       // Main app blue
  static const Color brandPrimarySoft = Color(0xFF66A8FF);   // Soft blue for dark mode

  static const Color brandSecondary = Color(0xFFFFB300);     // Primary gold
  static const Color brandSecondarySoft = Color(0xFFFFD861); // Soft gold


  // ------------------- BACKGROUND ---------------------
  static const Color bgLight = Color(0xFFF8F9FC);            // Light background
  static const Color bgDark = Color(0xFF111315);             // Dark background

  static const Color surfaceLight = Colors.white;            // Light card
  static const Color surfaceDark = Color(0xFF1A1C1E);        // Dark card


  // ------------------- TEXT COLORS ---------------------
  static const Color textPrimaryLight = Color(0xFF1A1A1A);   // Main light text
  static const Color textPrimaryDark = Colors.white;         // Main dark text

  static const Color textSecondaryLight = Color(0xFF3C3C3C); // Subtext light
  static const Color textSecondaryDark = Color(0xFFC9C9C9);  // Subtext dark


  // ------------------- SEMANTIC / STATUS ----------------
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF2196F3);


  // ============================================================================
  // 🌞 LIGHT THEME
  // ============================================================================
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    colorScheme: ColorScheme.light(
      primary: brandPrimary,
      secondary: brandSecondary,
      background: bgLight,
      surface: surfaceLight,
      onPrimary: Colors.white,  
      onSecondary: Colors.black,
      onBackground: textPrimaryLight,
      onSurface: textSecondaryLight,
      error: error,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: brandPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: textSecondaryLight,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );


  // ============================================================================
  // 🌙 DARK THEME
  // ============================================================================
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    colorScheme: ColorScheme.dark(
      primary: brandPrimarySoft,
      secondary: brandSecondarySoft,
      background: bgDark,
      surface: surfaceDark,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: textPrimaryDark,
      onSurface: textSecondaryDark,
      error: error,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: textSecondaryDark,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandPrimarySoft,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );


  // ============================================================================
  // 🔄 TOGGLE
  // ============================================================================
  void toggleTheme() => emit(ThemeState(isDarkMode: !state.isDarkMode));
}
