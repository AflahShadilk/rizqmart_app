import 'package:flutter/material.dart';
import 'package:responsive_display/responsive_display.dart';
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});


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
