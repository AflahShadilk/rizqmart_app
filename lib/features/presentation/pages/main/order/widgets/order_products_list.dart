import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/pages/main/order/widgets/order_product_item.dart';

// ---------------- Order Products List Section ----------------

class OrderProductsList extends StatelessWidget {
  // ---------------- Variables ----------------
  final OrderEntities order;

  // ---------------- Constructor ----------------
  const OrderProductsList({super.key, required this.order});

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items',
          style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        12.h,
        ...order.items.map((item) {
          return OrderProductItem(item: item, orderStatus: order.status);
        }),
      ],
    );
  }
}
