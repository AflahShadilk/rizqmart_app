import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_product_item.dart';

// displays the list of cart items in an order
class OrderProductsList extends StatelessWidget {
  final OrderEntities order;

  const OrderProductsList({super.key, required this.order});


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
