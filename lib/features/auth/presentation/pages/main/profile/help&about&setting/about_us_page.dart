// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

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
                24.h,
                buildMissionSection(context),
                24.h,
                buildValuesSection(context),
                24.h,
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
        12.h,
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
        12.h,
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

  Widget buildValuesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context, 'Our Values'),
        12.h,
        buildValueItem(
            context, 'Quality', 'We ensure only the finest products'),
        12.h,
        buildValueItem(context, 'Reliability', 'Fast and dependable delivery'),
        12.h,
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
        12.h,
        Row(
          children: [
            Expanded(
              child: buildStatCard(context, '50K+', 'Products'),
            ),
            12.w,
            Expanded(
              child: buildStatCard(context, '100K+', 'Customers'),
            ),
            12.w,
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
            4.h,
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
