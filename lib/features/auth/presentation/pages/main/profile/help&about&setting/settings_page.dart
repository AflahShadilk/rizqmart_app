import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/settings_appearance_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/settings_about_section.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
@override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
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
        body: const SingleChildScrollView(
          child: Column(
            children: [
              SettingsAppearanceSection(),
              SettingsAboutSection(),
            ],
          ),
        ),
      ),
    );
  }
}