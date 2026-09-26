

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/cubits/theme/theme_state.dart';



/// Manages the application's overall theme state (light/dark mode) and defines theme configurations.
class ThemeCubit extends Cubit<ThemeState> {
  
  
  ThemeCubit() : super(const ThemeState(isDarkMode: false));

  
  
  
  
  
  static const Color brandPrimary = Colors.green;
  
  
  static const Color brandPrimarySoft = Color(0xFF66BB6A);

  
  static const Color brandSecondary = Color(0xFFFFB300);
  
  
  static const Color brandSecondarySoft = Color(0xFFFFD861);

  
  
  
  
  
  static const Color bgLight = Color(0xFFF8F9FC);
  
  
  static const Color bgDark = Color(0xFF111315);

  
  
  
  
  
  static const Color surfaceLight = Colors.white;
  
  
  static const Color surfaceDark = Color(0xFF1A1C1E);

  
  
  
  
  
  static const Color textPrimaryLight = Colors.black;
  
  
  static const Color textPrimaryDark = Colors.white;

  
  static const Color textSecondaryLight = Color(0xFF3C3C3C);
  
  
  static const Color textSecondaryDark = Color(0xFFC9C9C9);

  
  
  
  
  
  static const Color success = Color(0xFF4CAF50);
  
  
  static const Color error = Color(0xFFE53935);
  
  
  static const Color warning = Color(0xFFFFB300);
  
  
  
  static const Color info = Color(0xFF2196F3);

  
  
  
  
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true, 

    
    colorScheme: ColorScheme.light(
      primary: brandPrimary,           
      secondary: brandSecondary,             
      surface: surfaceLight,           
      onPrimary: Colors.white,         
      onSecondary: Colors.black,  
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

  
  
  
  
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true, 

    
    colorScheme: ColorScheme.dark(
      primary: brandPrimarySoft,       
      secondary: brandSecondarySoft,              
      surface: surfaceDark,            
      onPrimary: Colors.white,         
      onSecondary: Colors.black,   
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

  
  
  
  
  
  
  void toggleTheme() => emit(ThemeState(isDarkMode: !state.isDarkMode));
}