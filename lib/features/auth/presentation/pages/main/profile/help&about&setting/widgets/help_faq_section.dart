import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Help FAQ Section ----------------

class HelpFaqSection extends StatelessWidget {
  const HelpFaqSection({super.key});

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

  Widget _buildFaqItem(
    BuildContext context,
    String question,
    String answer,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: context.ts.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        textColor: context.cs.primary,
        iconColor: context.cs.primary,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.7),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Frequently Asked Questions'),
        12.h,
        _buildFaqItem(
          context,
          'How long does delivery take?',
          'Quick Delivery: Within 1 hour\nStandard Delivery: 2-3 business days',
        ),
        12.h,
        _buildFaqItem(
          context,
          'Can I cancel my order?',
          'Orders can be cancelled within 30 minutes of placing. Contact support for assistance.',
        ),
        12.h,
        _buildFaqItem(
          context,
          'How do I return an item?',
          'Items can be returned within 7 days if unopened. Initiate return from Orders section.',
        ),
        12.h,
        _buildFaqItem(
          context,
          'Is my information secure?',
          'Yes, we use industry-standard encryption for all transactions and personal data.',
        ),
      ],
    );
  }
}
