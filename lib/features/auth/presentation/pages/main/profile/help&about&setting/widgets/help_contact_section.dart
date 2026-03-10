import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Help Contact Section ----------------

class HelpContactSection extends StatelessWidget {
  const HelpContactSection({super.key});

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

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.cs.primary,
              size: 24,
            ),
            16.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.ts.bodySmall?.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  4.h,
                  Text(
                    value,
                    style: context.ts.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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
        _buildSectionTitle(context, 'Contact Us'),
        12.h,
        _buildContactItem(
          context,
          Icons.email_outlined,
          'Email',
          'support@rizqmart.com',
        ),
        12.h,
        _buildContactItem(
          context,
          Icons.phone_outlined,
          'Phone',
          '+1 (234) 567-8900',
        ),
        12.h,
        _buildContactItem(
          context,
          Icons.location_on_outlined,
          'Address',
          '123 Market Street\nKakkanad, Kerala, India',
        ),
      ],
    );
  }
}
