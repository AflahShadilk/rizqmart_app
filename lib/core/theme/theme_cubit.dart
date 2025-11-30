// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/theme_state.dart';

/// Manages the app's theme state (light/dark mode)
/// Uses Cubit pattern for state management
class ThemeCubit extends Cubit<ThemeState> {
  /// Initialize with light mode as default
  /// Initialize with light mode as default
  ThemeCubit() : super(const ThemeState(isDarkMode: false));

  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND COLORS - Main app identity colors
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Primary brand color - Used for buttons, AppBar, active states (Light mode)
  static const Color brandPrimary = Colors.green;
  
  /// Softer version of primary - Used in dark mode for better contrast
  static const Color brandPrimarySoft = Color(0xFF66BB6A);

  /// Secondary accent color - Used for highlights and important elements
  static const Color brandSecondary = Color(0xFFFFB300);
  
  /// Softer version of secondary - Used in dark mode
  static const Color brandSecondarySoft = Color(0xFFFFD861);

  // ═══════════════════════════════════════════════════════════════════════════
  // BACKGROUND COLORS - Main screen backgrounds
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Light mode background - Soft blue-gray for comfortable viewing
  static const Color bgLight = Color(0xFFF8F9FC);
  
  /// Dark mode background - Deep dark for OLED displays
  static const Color bgDark = Color(0xFF111315);

  // ═══════════════════════════════════════════════════════════════════════════
  // SURFACE COLORS - Cards, containers, elevated surfaces
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Light mode surface - Pure white for cards and containers
  static const Color surfaceLight = Colors.white;
  
  /// Dark mode surface - Slightly lighter than background for depth
  static const Color surfaceDark = Color(0xFF1A1C1E);

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COLORS - Primary and secondary text
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Main text color for light mode - Pure black for maximum readability
  static const Color textPrimaryLight = Colors.black;
  
  /// Main text color for dark mode - Pure white for contrast
  static const Color textPrimaryDark = Colors.white;

  /// Secondary text for light mode - Gray for less important text
  static const Color textSecondaryLight = Color(0xFF3C3C3C);
  
  /// Secondary text for dark mode - Light gray for subtitles
  static const Color textSecondaryDark = Color(0xFFC9C9C9);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS - Status indicators and feedback
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Success state - Green for positive actions (order success, verification)
  static const Color success = Color(0xFF4CAF50);
  
  /// Error state - Red for errors and destructive actions
  static const Color error = Color(0xFFE53935);
  
  /// Warning state - Yellow/Gold for caution messages
  static const Color warning = Color(0xFFFFB300);
  
  /// Info state - Blue for informational messages
  /// Info state - Blue for informational messages
  static const Color info = Color(0xFF2196F3);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME - Complete theme configuration for light mode
  // ═══════════════════════════════════════════════════════════════════════════
  
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true, // Enable Material 3 design system

    /// Color scheme defines all semantic colors used throughout the app
    colorScheme: ColorScheme.light(
      primary: brandPrimary,           // Buttons, FAB, active elements
      secondary: brandSecondary,       // Accent highlights
      background: bgLight,             // Screen background
      surface: surfaceLight,           // Cards, dialogs, sheets
      onPrimary: Colors.white,         // Text/icons on primary color
      onSecondary: Colors.black,       // Text/icons on secondary color
      onBackground: textPrimaryLight,  // Text on background
      onSurface: textSecondaryLight,   // Text on surfaces
      error: error,                    // Error states
    ),

    /// AppBar styling - Consistent across all screens
    appBarTheme: AppBarTheme(
      backgroundColor: brandPrimary,   // Green AppBar
      foregroundColor: Colors.white,   // White text and icons
      elevation: 0,                    // Flat design (no shadow)
      titleTextStyle: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,   // Bold titles
        color: Colors.white,
      ),
    ),

    /// Text styling hierarchy - titleLarge for headers, bodyMedium for content
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

    /// Elevated button styling - Primary action buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandPrimary,  // Green button background
        foregroundColor: Colors.white,  // White text
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
      ),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME - Complete theme configuration for dark mode
  // ═══════════════════════════════════════════════════════════════════════════
  
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true, // Enable Material 3 design system

    /// Color scheme for dark mode - Uses softer colors for better eye comfort
    colorScheme: ColorScheme.dark(
      primary: brandPrimarySoft,       // Softer green for dark mode
      secondary: brandSecondarySoft,   // Softer gold accent
      background: bgDark,              // Deep black background
      surface: surfaceDark,            // Dark gray surfaces
      onPrimary: Colors.white,         // Text/icons on primary
      onSecondary: Colors.black,       // Text/icons on secondary
      onBackground: textPrimaryDark,   // White text on dark background
      onSurface: textSecondaryDark,    // Light gray text on surfaces
      error: error,                    // Error states
    ),

    /// AppBar for dark mode - Uses surface color instead of primary
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,    // Dark surface instead of green
      foregroundColor: Colors.white,   // White text and icons
      elevation: 0,                    // Flat design
      titleTextStyle: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),

    /// Text styling for dark mode
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,        // White for headers
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: textSecondaryDark,      // Light gray for body text
      ),
    ),

    /// Elevated buttons in dark mode - Uses soft green
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandPrimarySoft, // Soft green for dark mode
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // THEME TOGGLE - Switch between light and dark mode
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Toggles between light and dark theme
  /// Emits a new state with inverted isDarkMode value
  void toggleTheme() => emit(ThemeState(isDarkMode: !state.isDarkMode));
}