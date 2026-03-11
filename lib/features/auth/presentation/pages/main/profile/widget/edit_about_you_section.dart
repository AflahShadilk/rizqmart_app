import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_text_field.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Edit About You Section ----------------

class EditAboutYouSection extends StatelessWidget {
  final TextEditingController bioController;

  const EditAboutYouSection({
    super.key,
    required this.bioController,
  });

  // ---------------- Helper Methods ----------------

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: context.ts.labelLarge?.copyWith(
          color: context.cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionTitle(context, 'About You'),
        14.h,
        ProfileTextField(
          controller: bioController,
          label: 'Bio',
          icon: Icons.info_outline,
          enabled: true,
          maxLines: 3,
          helperText: 'Tell us about yourself',
        ),
      ],
    );
  }
}
