import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- About Mission Section ----------------

class AboutMissionSection extends StatelessWidget {
  const AboutMissionSection({super.key});

  // ---------------- Helper Methods ----------------

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.ts.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.cs.primary,
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              context.cs.primary.withValues(alpha: 0.05),
              context.cs.primary.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.flag, color: context.cs.primary, size: 32),
            12.h,
            Text(
              'To provide convenient, affordable, and high-quality grocery shopping experience to everyone',
              textAlign: TextAlign.center,
              style: context.ts.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.cs.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Our Mission'),
        12.h,
        _buildMissionCard(context),
      ],
    );
  }
}
