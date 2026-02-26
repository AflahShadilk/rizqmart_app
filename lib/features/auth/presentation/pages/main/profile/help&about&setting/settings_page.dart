

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/core/theme/theme_cubit.dart';
import 'package:rizqmart/core/theme/theme_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';


/// A configuration screen allowing users to toggle app preferences like dark mode and view app version information.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(child: Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: context.ts.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildThemeSection(context),
            buildAboutSection(context),
          ],
        ),
      ),
    ));
  }

  Widget buildThemeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(context, 'Appearance'),
          12.h,
          buildThemeToggleCard(context),
        ],
      ),
    );
  }

  Widget buildThemeToggleCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildThemeToggleContent(context),
            buildThemeToggleSwitch(context),
          ],
        ),
      ),
    );
  }

  Widget buildThemeToggleContent(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dark Mode',
            style: context.ts.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          4.h,
          Text(
            'Switch between light and dark theme',
            style: context.ts.bodySmall?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildThemeToggleSwitch(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Switch(
          value: state.isDarkMode,
          onChanged: (value) {
            context.read<ThemeCubit>().toggleTheme();
          },
          activeColor: context.cs.primary,
          inactiveThumbColor: Colors.grey,
        );
      },
    );
  }

  Widget buildAboutSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(context, 'About'),
          12.h,
          buildVersionCard(context),
          12.h,
          buildAboutUsCard(context),
        ],
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.ts.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.cs.primary,
      ),
    );
  }

  Widget buildVersionCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildVersionContent(context),
            buildVersionNumber(context),
          ],
        ),
      ),
    );
  }

  Widget buildVersionContent(BuildContext context) {
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

  Widget buildVersionNumber(BuildContext context) {
    return Text(
      '1.0.0',
      style: context.ts.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.cs.primary,
      ),
    );
  }

  Widget buildAboutUsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => showAboutUsDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildAboutUsContent(context),
              buildAboutUsArrow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAboutUsContent(BuildContext context) {
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

  Widget buildAboutUsArrow(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: context.cs.onSurface.withValues(alpha: 0.5),
    );
  }

  void showAboutUsDialog(BuildContext context) {
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
                buildAboutDialogSection(
                  context,
                  'About Us',
                  'RizqMart is your trusted online marketplace for fresh groceries and essentials. We deliver quality products to your doorstep with care and reliability.',
                ),
                16.h,
                buildAboutDialogSection(
                  context,
                  'Our Mission',
                  'To provide convenient, affordable, and high-quality grocery shopping experience to everyone.',
                ),
                16.h,
                buildAboutDialogSection(
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

  Widget buildAboutDialogSection(
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
}