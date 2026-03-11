import 'package:flutter/material.dart';
import 'package:responsive_display/responsive_display.dart';

// ---------------- Responsive Wrapper ----------------

/// A wrapper widget that ensures its child is rendered based on the current screen size's breakpoints.
class ResponsiveWrapper extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final Widget child;

  // ---------------- Constructor ----------------

  const ResponsiveWrapper({super.key, required this.child});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      xsmall: child,
      small: child,
      medium: child,
      large: child,
      xlarge: child,
    );
  }
}
