import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- About Values Section ----------------

class AboutValuesSection extends StatelessWidget {
  const AboutValuesSection({super.key});

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

  Widget _buildValueItem(BuildContext context, String title, String description) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: context.cs.primary,
                shape: BoxShape.circle,
              ),
            ),
            12.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.ts.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  2.h,
                  Text(
                    description,
                    style: context.ts.bodySmall?.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
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
        _buildSectionTitle(context, 'Our Values'),
        12.h,
        _buildValueItem(
            context, 'Quality', 'We ensure only the finest products'),
        12.h,
        _buildValueItem(context, 'Reliability', 'Fast and dependable delivery'),
        12.h,
        _buildValueItem(
            context, 'Customer First', 'Your satisfaction is our priority'),
      ],
    );
  }
}
