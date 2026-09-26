import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- About Hero Section ----------------

class AboutHeroSection extends StatelessWidget {
  const AboutHeroSection({super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cs.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: context.cs.primary.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.store_outlined,
            size: 64,
            color: context.cs.primary,
          ),
          12.h,
          Text(
            'RizqMart',
            style: context.ts.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.cs.primary,
            ),
          ),
          8.h,
          Text(
            'Your Trusted Online Marketplace',
            style: context.ts.bodyMedium?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
