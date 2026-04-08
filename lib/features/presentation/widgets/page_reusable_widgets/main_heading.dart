import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

// ---------------- App Heading ----------------

class AppHeading extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final String text;

  // ---------------- Constructor ----------------

  const AppHeading(this.text, {super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.ts.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: context.cs.onSurface,
      ),
    );
  }
}
