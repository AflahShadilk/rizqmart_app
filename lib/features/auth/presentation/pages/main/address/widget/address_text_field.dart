import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

/// A specialized text field styled specifically for various inputs within the address form context.
class AddressTextField extends StatelessWidget {

  // ---------------- Variables ----------------

  final String? initialValue;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final int? maxLength;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const AddressTextField({
    super.key,
    this.initialValue,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    required this.onChanged,
    this.validator,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      style: context.ts.bodyMedium?.copyWith(
        color: context.cs.onSurface,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.ts.bodySmall?.copyWith(
          color: context.cs.onSurfaceVariant,
          fontSize: 12,
        ),
        prefixIcon: Icon(
          icon,
          color: context.cs.onSurfaceVariant,
          size: 18,
        ),
        filled: true,
        fillColor: context.cs.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.error.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.error,
            width: 1.5,
          ),
        ),
        counterText: maxLength != null ? null : '',
        errorStyle: TextStyle(
          color: context.cs.error,
          fontSize: 11,
        ),
      ),
    );
  }
}
