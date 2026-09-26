import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

// ---------------- Google Sign-In Button ----------------

/// A custom styled Google Sign-In button wrapped with shadow effects.
class GoogleSignInButton extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final VoidCallback? onPressed;

  // ---------------- Constructor ----------------

  const GoogleSignInButton({
    super.key,
    this.onPressed,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: context.cs.shadow.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SignInButton(
        Buttons.Google,
        text: "Sign in with Google",
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        onPressed: onPressed,
      ),
    );
  }
}