import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

// ---------------- Auth Text Button ----------------

/// A specialized TextButton primarily used for authentication-related text links (like "Forgot Password?").
class AuthTextButton extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final VoidCallback? onPress;
  final String content;
  final Color color;

  // ---------------- Constructor ----------------

  const AuthTextButton({
    super.key,
    required this.onPress,
    required this.content,
    required this.color,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Text(
        content,
        style: context.ts.bodyMedium?.copyWith(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}