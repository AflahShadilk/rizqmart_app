import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_text_field.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class EditBasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const EditBasicInfoSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });
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
@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionTitle(context, 'Basic Information'),
        14.h,
        ProfileTextField(
          controller: nameController,
          label: 'Full Name',
          icon: Icons.person_outline,
          enabled: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name is required';
            }
            return null;
          },
          helperText: '',
        ),
        12.h,
        ProfileTextField(
          controller: emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          enabled: false,
          keyboardType: TextInputType.emailAddress,
          helperText: 'Email cannot be changed',
        ),
        12.h,
        ProfileTextField(
          controller: phoneController,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          enabled: true,
          keyboardType: TextInputType.phone,
          helperText: '',
        ),
      ],
    );
  }
}
