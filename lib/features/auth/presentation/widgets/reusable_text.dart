import 'package:flutter/material.dart';

// ---------------- Reusable Text ----------------

class ReusableText extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final String texts;
  final TextStyle? titleSize;

  // ---------------- Constructor ----------------

  const ReusableText({
    super.key,
    required this.texts,
    required this.titleSize,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Text(
      texts,
      style: titleSize,
    );
  }
}