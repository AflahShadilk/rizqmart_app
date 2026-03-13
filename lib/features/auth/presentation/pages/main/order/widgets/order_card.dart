import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/widgets/app_date_widget.dart';
import 'package:rizqmart/features/auth/presentation/widgets/app_time_widget.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20status/order_status_cubit.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_status_chip.dart';
class OrderCard extends StatelessWidget {
final OrderEntities order;
const OrderCard({super.key, required this.order});
@override
  Widget build(BuildContext context) {
    final String formattedOrderId = order.orderId.substring(0, 8).toUpperCase();
    final String formattedDate = '${AppDateWidget.format(order.createdAt)} • ${AppTimeWidget.format(order.createdAt)}';
    final String formattedCost = '₹${order.totalCost.toStringAsFixed(2)}';
    
    return BlocProvider(
      create: (_) => OrderStatusCubit(order.status),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: context.cs.surface,
        surfaceTintColor: context.cs.surfaceTint,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.orderDetails,
              arguments: order,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.cs.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.inventory_2_outlined, color: context.cs.primary),
                    ),
                    12.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #$formattedOrderId',
                            style: context.ts.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          4.h,
                          Text(
                            formattedDate,
                            style: context.ts.bodySmall?.copyWith(
                              color: context.cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const OrderStatusChip(),
                  ],
                ),
                16.h,
                Divider(color: context.cs.outlineVariant.withValues(alpha: 0.2)),
                16.h,
                Row(
                  children: [
                    Text(
                      '${order.items.length} Items',
                      style: context.ts.bodyMedium?.copyWith(
                        color: context.cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total Amount',
                          style: context.ts.bodySmall?.copyWith(fontSize: 10),
                        ),
                        Text(
                          formattedCost,
                          style: context.ts.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
