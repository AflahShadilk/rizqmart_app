import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/about_hero_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/about_company_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/about_mission_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/about_values_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/about_stats_section.dart';

// ---------------- About Us Page ----------------

/// An informative page detailing the company's background, mission, values, and general statistics.
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: context.cs.surface,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AboutHeroSection(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AboutCompanySection(),
                    24.h,
                    const AboutMissionSection(),
                    24.h,
                    const AboutValuesSection(),
                    24.h,
                    const AboutStatsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}