// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(isDarkMode: false));

  // 🌞 LIGHT THEME — clean, premium, trust-building (for eCommerce)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0061FF), // 🔹 Main brand color (used for buttons, highlights)
      secondary: Color(0xFFFFC107), // 🟡 Accent (used for offers, highlights)
      background: Color(0xFFF5F6FA), // 🩶 Page background
      surface: Colors.white, // 🧾 Card background (containers, tiles)
      onPrimary: Colors.white, // 🖋️ Text color on primary (button text)
      onSecondary: Colors.black, // Text color on accent
      onBackground: Color(0xFF1C1C1C), // 🖤 Default text color
      onSurface: Color(0xFF2C2C2C), // Slightly lighter text for cards
      error: Color(0xFFE53935), // ❌ Error messages or delete actions
    ),

    // 🧭 AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0061FF), // Same as primary for brand consistency
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // 🧩 Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0061FF), // Button background
        foregroundColor: Colors.white, // Button text
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),

    // 🏷️ Text
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1C)),
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
      labelLarge: TextStyle(fontSize: 14, color: Colors.white),
    ),

    // 📦 Card / Container look
    cardColor: Colors.white,
    useMaterial3: true,
  );

  // 🌙 DARK THEME — modern, elegant, eye-friendly
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3399FF), // 🔹 Softer blue for dark mode buttons
      secondary: Color(0xFFFFD54F), // 🟡 Warm accent color
      background: Color(0xFF0F0F0F), // 🌑 App background
      surface: Color(0xFF1C1C1C), // 🩶 Card background
      onPrimary: Colors.black, // Text on blue button
      onSecondary: Colors.black, // Text on accent color
      onBackground: Colors.white, // Main text color
      onSurface: Color(0xFFCCCCCC), // Secondary text (less bright)
      error: Color(0xFFFF5252), // ❌ Error color
    ),

    // 🧭 AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // 🧩 Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF3399FF), // Button color
        foregroundColor: Colors.black, // Text color on button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),

    // 🏷️ Text
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFCCCCCC)),
      labelLarge: TextStyle(fontSize: 14, color: Colors.black),
    ),

    // 📦 Card / Container look
    cardColor: Color(0xFF1C1C1C),
    useMaterial3: true,
  );

  // 🔄 Toggle between themes
  void toggleTheme() => emit(ThemeState(isDarkMode: !state.isDarkMode));
}