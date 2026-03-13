import 'package:flutter/material.dart';
extension DividerExtension on BuildContext {
  Divider divider({
    double thickness = 1,
    Color? color,
    double? height,
    double? indent,
    double? endIndent,
  }) {
    return Divider(
      thickness: thickness,
      color: color ?? Theme.of(this).colorScheme.outlineVariant,
      height: height,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
