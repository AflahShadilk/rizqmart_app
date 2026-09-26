import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- Help Getting Started Section ----------------

class HelpGettingStartedSection extends StatelessWidget {
  const HelpGettingStartedSection({super.key});

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
        _buildSectionTitle(context, 'Getting Started'),
        12.h,
        _buildFaqItem(
          context,
          'How do I place an order?',
          '1. Browse products\n2. Add items to cart\n3. Proceed to checkout\n4. Select delivery address\n5. Choose payment method\n6. Confirm order',
        ),
        12.h,
        _buildFaqItem(
          context,
          'What payment methods do you accept?',
          'We accept Cash on Delivery (COD) and PayPal for secure online payments.',
        ),
      ],
    );
  }
}
