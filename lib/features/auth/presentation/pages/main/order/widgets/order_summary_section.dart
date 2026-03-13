import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class OrderSummarySection extends StatelessWidget {
final OrderEntities order;
const OrderSummarySection({super.key, required this.order});
Widget _summaryRow(BuildContext context, String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.ts.bodyMedium),
        Text(
          '${isDiscount ? "-" : ""}₹${amount.abs().toStringAsFixed(2)}',
          style: context.ts.bodyMedium?.copyWith(
            color: isDiscount ? AppColors.success500 : context.cs.onSurface,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
@override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        12.h,
        _summaryRow(context, 'Subtotal', order.subtotal),
        8.h,
        _summaryRow(context, 'Delivery Fee', order.deliveryFee),
        8.h,
        _summaryRow(context, 'Discount', order.discount, isDiscount: true),
        if ((order.discountAmount ?? 0) > 0) ...[
          8.h,
          _summaryRow(context, 'Coupon Discount${order.couponName != null ? ' (${order.couponName})' : ''}', order.discountAmount!, isDiscount: true),
        ],
        12.h,
        Divider(color: context.cs.outlineVariant),
        12.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount',
              style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '₹${order.totalCost.toStringAsFixed(2)}',
              style: context.ts.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.cs.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
