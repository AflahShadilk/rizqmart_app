import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- About Stats Section ----------------

class AboutStatsSection extends StatelessWidget {
  const AboutStatsSection({super.key});

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

  Widget _buildStatCard(BuildContext context, String number, String label) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              context.cs.primary.withValues(alpha: 0.1),
              context.cs.primary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: context.ts.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.cs.primary,
              ),
            ),
            4.h,
            Text(
              label,
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.6),
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
        _buildSectionTitle(context, 'By The Numbers'),
        12.h,
        Row(
          children: [
            Expanded(
              child: _buildStatCard(context, '50K+', 'Products'),
            ),
            12.w,
            Expanded(
              child: _buildStatCard(context, '100K+', 'Customers'),
            ),
            12.w,
            Expanded(
              child: _buildStatCard(context, '24/7', 'Support'),
            ),
          ],
        ),
      ],
    );
  }
}
