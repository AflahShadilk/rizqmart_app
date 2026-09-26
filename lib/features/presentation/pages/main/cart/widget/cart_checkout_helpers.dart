import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

/// A tappable row used in checkout flows showing an icon, title, trailing text, and forward arrow.
Widget checkoutRow(
  BuildContext context, {
  IconData? icon,
  required String title,
  required String trailing,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.cs.primary,
            size: 18,
          ),
          10.w,
          Text(
            title,
            style: context.ts.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.cs.onSurface.withValues(alpha: 0.5)),
          ),
          const Spacer(),
          Text(
            trailing,
            style: context.ts.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          8.w,
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: context.cs.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
    ),
  );
}

/// A row displaying a label and formatted currency amount, optionally styled as a discount.
Widget costRow(
  BuildContext context,
  String label,
  double amount, {
  bool isDiscount = false,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: context.ts.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
      Text(
        '${isDiscount ? '-' : ''}₹${amount.abs().toStringAsFixed(2)}',
        style: context.ts.bodyLarge?.copyWith(
          color: isDiscount ? context.cs.success : context.cs.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
