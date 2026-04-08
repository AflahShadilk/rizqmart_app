import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

// ---------------- Not Found Page ----------------

/// A fallback page displayed when a requested route or product is not found.
class NotFoundPage extends StatelessWidget {
  
  // ---------------- Constructor ----------------

  const NotFoundPage({super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        body: Center(
          child: Text(
            "404 - Page Not Found!",
            style: context.ts.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}