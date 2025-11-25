import 'package:flutter/material.dart';

extension ContextTheme on BuildContext {
  // ColorScheme
  ColorScheme get cs => Theme.of(this).colorScheme;

  //TextTheme
  TextTheme get ts => Theme.of(this).textTheme;

  //Brightness
  Brightness get brightness => Theme.of(this).brightness;
  

}
