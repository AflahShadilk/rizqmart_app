

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

/// A selectable widget presenting available gender options (Male, Female, Other) for user profiles.
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
    
    if (!enabled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.cs.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.cs.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.wc,
              color: context.cs.onSurfaceVariant,
              size: 20,
            ),
            16.w,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gender',
                  style: context.ts.labelSmall?.copyWith(
                    color: context.cs.onSurfaceVariant,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                4.h,
                Text(
                  selectedGender ?? 'Not specified',
                  style: context.ts.bodyMedium?.copyWith(
                    color: context.cs.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cs.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wc,
                color: context.cs.primary,
                size: 20,
              ),
              12.w,
              Text(
                'Gender',
                style: context.ts.labelMedium?.copyWith(
                  color: context.cs.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          16.h,
          Row(
            children: [
              Expanded(
                child: GenderOption(
                  label: 'Male',
                  icon: Icons.male,
                  isSelected: selectedGender == 'Male',
                  enabled: enabled,
                  onTap: () => onGenderSelected('Male'),
                ),
              ),
              10.w,
              Expanded(
                child: GenderOption(
                  label: 'Female',
                  icon: Icons.female,
                  isSelected: selectedGender == 'Female',
                  enabled: enabled,
                  onTap: () => onGenderSelected('Female'),
                ),
              ),
              10.w,
              Expanded(
                child: GenderOption(
                  label: 'Other',
                  icon: Icons.transgender,
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
  final IconData icon;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const GenderOption({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        highlightColor: context.cs.primary.withValues(alpha: 0.1),
        splashColor: context.cs.primary.withValues(alpha: 0.15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? context.cs.primary.withValues(alpha: 0.12)
                : context.cs.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? context.cs.primary
                  : context.cs.outlineVariant.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? context.cs.primary
                    : context.cs.onSurfaceVariant,
                size: 24,
              ),
              6.h,
              Text(
                label,
                style: context.ts.labelSmall?.copyWith(
                  color: isSelected
                      ? context.cs.primary
                      : context.cs.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}