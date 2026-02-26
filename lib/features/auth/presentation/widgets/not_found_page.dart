import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

/// A fallback page displayed when a requested route or product is not found.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(child: Scaffold(
      body: Center(
        child: Text("404 - Page Not Found!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ));
  }
}