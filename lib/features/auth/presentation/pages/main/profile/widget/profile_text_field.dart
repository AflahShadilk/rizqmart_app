import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool enabled;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.enabled,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator, required String helperText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: context.ts.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.ts.bodyMedium?.copyWith(
          color: context.cs.onSurfaceVariant,
        ),
        prefixIcon: Icon(icon, color: context.cs.onSurfaceVariant),
        filled: true,
        fillColor: enabled
            ? context.cs.surfaceContainerHighest
            // ignore: deprecated_member_use
            : context.cs.surfaceContainerHighest.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.cs.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.cs.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.cs.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

