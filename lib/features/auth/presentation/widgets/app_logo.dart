import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/icon_and_name.dart';

// ---------------- App Logo ----------------

/// A composite logo display combining the RizqMart icon and stylized text within a decorative container.
class CommonAppLogo extends StatelessWidget {
  
  // ---------------- Constructor ----------------

  const CommonAppLogo({
    super.key,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(150),
          bottom: Radius.circular(150),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IconRizq(),
          12.h,
          const RizqMartName(),
        ],
      ),
    );
  }
}