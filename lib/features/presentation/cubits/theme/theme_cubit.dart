

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/cubits/theme/theme_state.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:rizqmart/core/theme/app_colors.dart';

/// Manages the application's overall theme state (light/dark mode) and defines theme configurations.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(isDarkMode: false));

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.accentOrange,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      error: AppColors.statusCancelled,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    ),

    textTheme: GoogleFonts.manropeTextTheme(ThemeData.light().textTheme).copyWith(
      titleLarge: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 16,
        color: AppColors.textSecondary,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF111315),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.accentOrange,
      surface: Color(0xFF1A1C1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFF7F8FA),
      error: AppColors.statusCancelled,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF111315),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),

    textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme).copyWith(
      titleLarge: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 16,
        color: const Color(0xFFC9C9C9),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  void toggleTheme() => emit(ThemeState(isDarkMode: !state.isDarkMode));
}