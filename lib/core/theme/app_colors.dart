

import 'package:flutter/material.dart';

/// Contains all the standard color palettes and semantic colors used throughout the application design.
class AppColors {
  

  
  static const Color primary500 = Color(0xFF3B82F6); 
  static const Color primary600 = Color(0xFF2563EB); 
  static const Color primary400 = Color(0xFF60A5FA); 

  
  static const Color secondary500 = Color(0xFFF97316);
  static const Color secondary600 = Color(0xFFEA580C);
  static const Color secondary400 = Color(0xFFFB923C);

  
  static const Color grey900 = Color(0xFF111827); 
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey500 = Color(0xFF6B7280); 
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey50  = Color(0xFFFAFAFA);

  
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  
  static const Color success500 = Color(0xFF16A34A);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color error500   = Color(0xFFDC2626);
  static const Color info500    = Color(0xFF0284C7);

  
  static Color black50  = black.withValues(alpha: 0.5);
  static Color black25  = black.withValues(alpha: 0.25);
  static Color black10  = black.withValues(alpha: 0.10);

  static Color white80  = white.withValues(alpha: 0.80);
  static Color white50  = white.withValues(alpha: 0.50);
  static Color white20  = white.withValues(alpha: 0.20);

  
  static const Color lightBackground = white;
  static const Color lightCard       = grey50;
  static const Color lightText       = grey900;

  
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCard       = grey800;
  static const Color darkText       = grey50;

  // Explore Module Category Card Colors
  static const List<Color> exploreLightCards = [
    Color(0xFFFFF3E0),
    Color(0xFFE8F5E8),
    Color(0xFFE3F2FD),
    Color(0xFFFFEBEE),
    Color(0xFFF3E5F5),
    Color(0xFFFFFDE7),
    Color(0xFFE0F7FA),
    Color(0xFFFCE4EC),
  ];

  static const List<Color> exploreDarkCards = [
    Color(0xFF332800),
    Color(0xFF0A2B0A),
    Color(0xFF0A1929),
    Color(0xFF2D0A0A),
    Color(0xFF1A0A2B),
    Color(0xFF2B2800),
    Color(0xFF002B2B),
    Color(0xFF2B0A14),
  ];

  // Address Module Label Colors
  static const Color addressLabelHome  = Color(0xFF6366F1);
  static const Color addressLabelWork  = Color(0xFF0EA5E9);
  static const Color addressLabelOther = Color(0xFF8B5CF6);

  // Chat Module Colors
  static const Color chatErrorBackground = Color.fromRGBO(244, 67, 54, 0.1);
  static Color chatErrorIcon = const Color.fromRGBO(244, 67, 54, 0.7);
  static const Color chatErrorText = Color(0xFFF44336);
}
