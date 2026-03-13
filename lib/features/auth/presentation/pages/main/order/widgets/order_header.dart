import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/widgets/app_date_widget.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// displays order id and date at the top of order details

class OrderHeader extends StatelessWidget {
  final OrderEntities order;

  const OrderHeader({super.key, required this.order});


  @override
  Widget build(BuildContext context) {
    final String formattedOrderId = '#${order.orderId.substring(0, 8).toUpperCase()}';
    final String formattedDate = AppDateWidget.format(order.createdAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest.withAlpha(77),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.cs.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order ID', style: context.ts.bodyMedium),
              Text(
                formattedOrderId,
                style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          8.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date', style: context.ts.bodyMedium),
              Text(
                formattedDate,
                style: context.ts.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
