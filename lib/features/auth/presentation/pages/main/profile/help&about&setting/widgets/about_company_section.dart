import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class AboutCompanySection extends StatelessWidget {
  const AboutCompanySection({super.key});
Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.ts.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.cs.primary,
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context, String content) {
    return Text(
      content,
      style: context.ts.bodyMedium?.copyWith(
        color: context.cs.onSurface.withValues(alpha: 0.7),
        height: 1.6,
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'About RizqMart'),
        12.h,
        _buildSectionContent(
          context,
          'RizqMart is your trusted online marketplace for fresh groceries and everyday essentials. '
          'We are committed to delivering quality products directly to your doorstep with the utmost care and reliability.\n\n'
          'Founded with a vision to revolutionize online shopping, we strive to make grocery shopping convenient, '
          'affordable, and accessible to everyone.',
        ),
      ],
    );
  }
}
