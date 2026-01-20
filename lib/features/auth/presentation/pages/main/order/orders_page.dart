
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const GetUserOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);

    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, AppRoutes.navigationBar);
      },
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false, // We handle leading manually
          leading: canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.navigationBar),
                ),
          title: Text(
            'My Orders',
            style: context.ts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: context.cs.surface,
          elevation: 0,
        ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
           if (state is OrderSuccessState) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: Text(state.message),
                 backgroundColor: Colors.green,
               ),
             );
           }
        },
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderSuccessState) {
             // Order cancelled successfully, reload data
             context.read<OrderBloc>().add(const GetUserOrdersEvent());
             return const Center(child: CircularProgressIndicator());
          } else if (state is OrderErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: context.cs.error),
                  16.h,
                  Text('Error: ${state.message}'),
                  TextButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(const GetUserOrdersEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is OrdersLoadedState) {
            if (state.orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: context.cs.onSurface.withAlpha(77), // 0.3 opacity
                    ),
                    16.h,
                    Text(
                      'No orders yet',
                      style: context.ts.titleMedium,
                    ),
                    8.h,
                    Text(
                      'Start shopping to see your orders here',
                      style: context.ts.bodySmall?.copyWith(
                        color: context.cs.onSurface.withAlpha(128), // 0.5 opacity
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (context, index) => 16.h,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return _OrderCard(order: order);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ));
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntities order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       color: context.cs.primaryContainer.withOpacity(0.4),
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
                           'Order #${order.orderId.substring(0, 8).toUpperCase()}',
                           style: context.ts.titleMedium?.copyWith(
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         4.h,
                         Text(
                           DateFormat('MMM dd, yyyy • hh:mm a')
                               .format(order.createdAt),
                           style: context.ts.bodySmall?.copyWith(
                             color: context.cs.onSurface.withOpacity(0.6),
                           ),
                         ),
                       ],
                     ),
                   ),
                  _StatusChip(status: order.status),
                ],
              ),
              16.h,
              Divider(color: context.cs.outlineVariant.withOpacity(0.2)),
              16.h,
              Row(
                children: [
                  Text(
                    '${order.items.length} Items',
                    style: context.ts.bodyMedium?.copyWith(
                       color: context.cs.onSurface.withOpacity(0.7),
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
                        '₹${order.totalCost.toStringAsFixed(2)}',
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
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
      case 'pending_payment':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'processing':
        color = Colors.blue;
        label = 'Processing';
        break;
      case 'shipped':
      case 'out_for_delivery':
        color = Colors.purple;
        label = 'Shipped';
        break;
      case 'delivered':
        color = Colors.green;
        label = 'Delivered';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(26), // 0.1 opacity
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(128)), // 0.5 opacity
      ),
      child: Text(
        label, // Use the mapped label
        style: context.ts.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
