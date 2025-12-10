// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class DateOfBirthField extends StatelessWidget {
  final DateTime? selectedDate;
  final bool enabled;
  final Function(DateTime?) onDateSelected;

  const DateOfBirthField({
    super.key,
    required this.selectedDate,
    required this.enabled,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              onDateSelected(date);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: enabled
              ? context.cs.surfaceContainerHighest
              : context.cs.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: context.cs.onSurfaceVariant,
            ),
            16.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date of Birth',
                    style: context.ts.bodyMedium?.copyWith(
                      color: context.cs.onSurfaceVariant,
                    ),
                  ),
                  4.h,
                  Text(
                    selectedDate != null
                        ? MaterialLocalizations.of(context)
                            .formatShortDate(selectedDate!)
                        : 'Not set',
                    style: context.ts.bodyLarge,
                  ),
                ],
              ),
            ),
            if (enabled)
              Icon(
                Icons.arrow_forward_ios,
                color: context.cs.onSurfaceVariant,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

