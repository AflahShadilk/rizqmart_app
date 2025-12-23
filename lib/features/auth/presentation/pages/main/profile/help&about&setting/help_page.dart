// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.background,
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: context.ts.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: buildHelpContent(context),
    );
  }

  Widget buildHelpContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHelpSection(context),
            const SizedBox(height: 24),
            buildFaqSection(context),
            const SizedBox(height: 24),
            buildContactSection(context),
          ],
        ),
      ),
    );
  }

  Widget buildHelpSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context, 'Getting Started'),
        const SizedBox(height: 12),
        buildFaqItem(
          context,
          'How do I place an order?',
          '1. Browse products\n2. Add items to cart\n3. Proceed to checkout\n4. Select delivery address\n5. Choose payment method\n6. Confirm order',
        ),
        const SizedBox(height: 12),
        buildFaqItem(
          context,
          'What payment methods do you accept?',
          'We accept Cash on Delivery (COD) and PayPal for secure online payments.',
        ),
      ],
    );
  }

  Widget buildFaqSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context, 'Frequently Asked Questions'),
        const SizedBox(height: 12),
        buildFaqItem(
          context,
          'How long does delivery take?',
          'Quick Delivery: Within 1 hour\nStandard Delivery: 2-3 business days',
        ),
        const SizedBox(height: 12),
        buildFaqItem(
          context,
          'Can I cancel my order?',
          'Orders can be cancelled within 30 minutes of placing. Contact support for assistance.',
        ),
        const SizedBox(height: 12),
        buildFaqItem(
          context,
          'How do I return an item?',
          'Items can be returned within 7 days if unopened. Initiate return from Orders section.',
        ),
        const SizedBox(height: 12),
        buildFaqItem(
          context,
          'Is my information secure?',
          'Yes, we use industry-standard encryption for all transactions and personal data.',
        ),
      ],
    );
  }

  Widget buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context, 'Contact Us'),
        const SizedBox(height: 12),
        buildContactItem(
          context,
          Icons.email_outlined,
          'Email',
          'support@rizqmart.com',
        ),
        const SizedBox(height: 12),
        buildContactItem(
          context,
          Icons.phone_outlined,
          'Phone',
          '+1 (234) 567-8900',
        ),
        const SizedBox(height: 12),
        buildContactItem(
          context,
          Icons.location_on_outlined,
          'Address',
          '123 Market Street\nKakkanad, Kerala, India',
        ),
      ],
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.ts.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.cs.primary,
      ),
    );
  }

  Widget buildFaqItem(
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
                color: context.cs.onSurface.withOpacity(0.7),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContactItem(
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.ts.bodySmall?.copyWith(
                      color: context.cs.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
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
}