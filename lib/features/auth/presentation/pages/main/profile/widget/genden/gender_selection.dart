// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final bool enabled;
  final Function(String?) onGenderSelected;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.enabled,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: enabled
            ? context.cs.surfaceContainerHighest
            : context.cs.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people_outline,
                color: context.cs.onSurfaceVariant,
              ),
              16.w,
              Text(
                'Gender',
                style: context.ts.bodyMedium?.copyWith(
                  color: context.cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          8.h,
          Row(
            children: [
              Expanded(
                child: GenderOption(
                  label: 'Male',
                  isSelected: selectedGender == 'Male',
                  enabled: enabled,
                  onTap: () => onGenderSelected('Male'),
                ),
              ),
              12.w,
              Expanded(
                child: GenderOption(
                  label: 'Female',
                  isSelected: selectedGender == 'Female',
                  enabled: enabled,
                  onTap: () => onGenderSelected('Female'),
                ),
              ),
              12.w,
              Expanded(
                child: GenderOption(
                  label: 'Other',
                  isSelected: selectedGender == 'Other',
                  enabled: enabled,
                  onTap: () => onGenderSelected('Other'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const GenderOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? context.cs.primaryContainer : context.cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? context.cs.primary : context.cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: context.ts.bodyMedium?.copyWith(
              color: isSelected
                  ? context.cs.onPrimaryContainer
                  : context.cs.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}