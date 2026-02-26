import 'package:flutter/material.dart';

/// Convenience extension on BuildContext to quickly access current theme properties.
extension ContextTheme on BuildContext {
  
  ColorScheme get cs => Theme.of(this).colorScheme;

  
  TextTheme get ts => Theme.of(this).textTheme;

  
  Brightness get brightness => Theme.of(this).brightness;
  bool get isDarkMode => brightness == Brightness.dark;
}
