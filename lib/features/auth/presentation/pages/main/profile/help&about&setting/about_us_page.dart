// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.background,
      appBar: AppBar(
        title: Text(
          'About Us',
          style: context.ts.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: buildAboutContent(context),
    );
  }

  Widget buildAboutContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildAboutHeroSection(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAboutSection(context),
                const SizedBox(height: 24),
                buildMissionSection(context),
                const SizedBox(height: 24),
                buildValuesSection(context),
                const SizedBox(height: 24),
                buildStatsSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAboutHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cs.primary.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: context.cs.primary.withOpacity(0.2),
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
          const SizedBox(height: 12),
          Text(
            'RizqMart',
            style: context.ts.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.cs.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Trusted Online Marketplace',
            style: context.ts.bodyMedium?.copyWith(
              color: context.cs.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context, 'About RizqMart'),
        const SizedBox(height: 12),
        buildSectionContent(
          context,
          'RizqMart is your trusted online marketplace for fresh groceries and everyday essentials. '
          'We are committed to delivering quality products directly to your doorstep with the utmost care and reliability.\n\n'
          'Founded with a vision to revolutionize online shopping, we strive to make grocery shopping convenient, '
          'affordable, and accessible to everyone.',
        ),
      ],
    );
  }

  Widget buildMissionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context, 'Our Mission'),
        const SizedBox(height: 12),
        buildMissionCard(context),
      ],
    );
  }

  Widget buildMissionCard(BuildContext context) {
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
              context.cs.primary.withOpacity(0.05),
              context.cs.primary.withOpacity(0.02),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.flag, color: context.cs.primary, size: 32),
            const SizedBox(height: 12),
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

  Widget buildValuesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context, 'Our Values'),
        const SizedBox(height: 12),
        buildValueItem(
            context, 'Quality', 'We ensure only the finest products'),
        const SizedBox(height: 12),
        buildValueItem(context, 'Reliability', 'Fast and dependable delivery'),
        const SizedBox(height: 12),
        buildValueItem(
            context, 'Customer First', 'Your satisfaction is our priority'),
      ],
    );
  }

  Widget buildValueItem(
      BuildContext context, String title, String description) {
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
            const SizedBox(width: 12),
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
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: context.ts.bodySmall?.copyWith(
                      color: context.cs.onSurface.withOpacity(0.6),
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

  Widget buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context, 'By The Numbers'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildStatCard(context, '50K+', 'Products'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildStatCard(context, '100K+', 'Customers'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildStatCard(context, '24/7', 'Support'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildStatCard(BuildContext context, String number, String label) {
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
              context.cs.primary.withOpacity(0.1),
              context.cs.primary.withOpacity(0.05),
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
            const SizedBox(height: 4),
            Text(
              label,
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
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

  Widget buildSectionContent(BuildContext context, String content) {
    return Text(
      content,
      style: context.ts.bodyMedium?.copyWith(
        color: context.cs.onSurface.withOpacity(0.7),
        height: 1.6,
      ),
    );
  }
}
