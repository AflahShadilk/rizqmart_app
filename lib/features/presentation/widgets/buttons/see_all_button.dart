import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

// ---------------- See All Button ----------------

/// A stylized TextButton used for 'See all' navigation links.
class ReusableSeeAllButton extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final VoidCallback onPress;

  // ---------------- Constructor ----------------

  const ReusableSeeAllButton({
    super.key,
    required this.onPress,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Text(
        'See all',
        style: context.ts.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: context.cs.primary,
        ),
      ),
    );
  }
}
