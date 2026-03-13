import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/help_getting_started_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/help_faq_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/help&about&setting/widgets/help_contact_section.dart';
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});
@override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: context.cs.surface,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HelpGettingStartedSection(),
                24.h,
                const HelpFaqSection(),
                24.h,
                const HelpContactSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}