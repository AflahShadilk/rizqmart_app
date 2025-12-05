// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  // BRAND COLORS -----------------------------------------------------

  // Primary (Main brand color)
  static const Color primary500 = Color(0xFF3B82F6); // Standard brand
  static const Color primary600 = Color(0xFF2563EB); // Darker
  static const Color primary400 = Color(0xFF60A5FA); // Lighter

  // Secondary (Support color)
  static const Color secondary500 = Color(0xFFF97316);
  static const Color secondary600 = Color(0xFFEA580C);
  static const Color secondary400 = Color(0xFFFB923C);

  // NEUTRAL GREYS ----------------------------------------------------
  static const Color grey900 = Color(0xFF111827); // Text heading
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey500 = Color(0xFF6B7280); // Secondary text
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey50  = Color(0xFFFAFAFA);

  // WHITE & BLACK ----------------------------------------------------
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // STATUS & ALERTS --------------------------------------------------
  static const Color success500 = Color(0xFF16A34A);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color error500   = Color(0xFFDC2626);
  static const Color info500    = Color(0xFF0284C7);

  // TRANSPARENCY (UTILITY) -------------------------------------------
  static Color black50  = black.withOpacity(0.5);
  static Color black25  = black.withOpacity(0.25);
  static Color black10  = black.withOpacity(0.10);

  static Color white80  = white.withOpacity(0.80);
  static Color white50  = white.withOpacity(0.50);
  static Color white20  = white.withOpacity(0.20);

  // LIGHT THEME BASE -------------------------------------------------
  static const Color lightBackground = white;
  static const Color lightCard       = grey50;
  static const Color lightText       = grey900;

  // DARK THEME BASE --------------------------------------------------
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCard       = grey800;
  static const Color darkText       = grey50;
}
