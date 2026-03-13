import 'package:flutter/material.dart';
extension ContextTheme on BuildContext {
  
  ColorScheme get cs => Theme.of(this).colorScheme;

  
  TextTheme get ts => Theme.of(this).textTheme;

  
  Brightness get brightness => Theme.of(this).brightness;
  bool get isDarkMode => brightness == Brightness.dark;
}
