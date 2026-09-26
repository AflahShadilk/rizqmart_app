import 'package:flutter/material.dart';

// ---------------- Responsive Utility ----------------

/// A utility class providing static methods to determine the current screen size for responsive layouts.
class Responsive {
  
  // ---------------- Helper Methods ----------------

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;
}