import 'package:flutter/material.dart';

// ---------------- Custom Circular Progress Indicator ----------------

/// A centered CircularProgressIndicator with a custom linear gradient shader mask.
class CustomCircularProgressIndicator extends StatelessWidget {
  
  // ---------------- Constructor ----------------

  const CustomCircularProgressIndicator({super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Colors.purple, Colors.blue, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: const SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}