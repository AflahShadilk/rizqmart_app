import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Settings About Section ----------------

class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  // ---------------- Helper Methods ----------------

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.ts.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.cs.primary,
      ),
    );
  }

  Widget _buildVersionContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App Version',
          style: context.ts.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        4.h,
        Text(
          'Current version installed',
          style: context.ts.bodySmall?.copyWith(
            color: context.cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildVersionNumber(BuildContext context) {
    return Text(
      '1.0.0',
      style: context.ts.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.cs.primary,
      ),
    );
  }

  Widget _buildVersionCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildVersionContent(context),
            _buildVersionNumber(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutUsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Us',
          style: context.ts.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        4.h,
        Text(
          'Learn more about RizqMart',
          style: context.ts.bodySmall?.copyWith(
            color: context.cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutUsArrow(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: context.cs.onSurface.withValues(alpha: 0.5),
    );
  }

  Widget _buildAboutDialogSection(
    BuildContext context,
    String title,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.ts.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.cs.primary,
          ),
        ),
        6.h,
        Text(
          content,
          style: context.ts.bodySmall?.copyWith(
            color: context.cs.onSurface.withValues(alpha: 0.7),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  void _showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'About RizqMart',
            style: context.ts.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAboutDialogSection(
                  context,
                  'About Us',
                  'RizqMart is your trusted online marketplace for fresh groceries and essentials. We deliver quality products to your doorstep with care and reliability.',
                ),
                16.h,
                _buildAboutDialogSection(
                  context,
                  'Our Mission',
                  'To provide convenient, affordable, and high-quality grocery shopping experience to everyone.',
                ),
                16.h,
                _buildAboutDialogSection(
                  context,
                  'Contact',
                  'Email: support@rizqmart.com\nPhone: +1 234 567 8900',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Close',
                style: context.ts.labelMedium?.copyWith(
                  color: context.cs.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutUsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showAboutUsDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAboutUsContent(context),
              _buildAboutUsArrow(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'About'),
          12.h,
          _buildVersionCard(context),
          12.h,
          _buildAboutUsCard(context),
        ],
      ),
    );
  }
}
