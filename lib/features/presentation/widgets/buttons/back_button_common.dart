import 'package:flutter/material.dart';

// ---------------- Back Button Common ----------------

/// A universally used back button that pops the current navigation context.
class BackButtonCommon extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final ColorScheme? colorScheme;

  // ---------------- Constructor ----------------

  const BackButtonCommon({
    super.key,
    this.colorScheme,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    final activeColorScheme = colorScheme ?? Theme.of(context).colorScheme;
    
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_ios_new_outlined,
        color: activeColorScheme.onSecondary,
        size: 20,
      ),
    );
  }
}