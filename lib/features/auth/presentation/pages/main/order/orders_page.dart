import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20status/order_status_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20status/order_status_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/orders/orders_page_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/orders/orders_page_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrdersPageCubit(orderBloc: context.read<OrderBloc>()),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);

    return BlocListener<OrdersPageCubit, OrdersPageState>(
      listener: (context, state) {
        if (state is OrdersPageCancelSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: PopScope(
        canPop: canPop,
        onPopInvoked: (didPop) {
          if (didPop) return;
          Navigator.pushReplacementNamed(context, AppRoutes.navigationBar);
        },
        child: Scaffold(
          backgroundColor: context.cs.surface,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (canPop) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.navigationBar);
                }
              },
            ),
            title: Text(
              'My Orders',
              style:
                  context.ts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: context.cs.surface,
            elevation: 0,
          ),
          body: BlocBuilder<OrdersPageCubit, OrdersPageState>(
            builder: (context, state) {
              if (state is OrdersPageLoading || state is OrdersPageInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is OrdersPageError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: context.cs.error),
                      16.h,
                      Text('Error: ${state.message}'),
                      TextButton(
                        onPressed: () =>
                            context.read<OrdersPageCubit>().retryLoad(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is OrdersPageEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: context.cs.onSurface.withAlpha(77),
                      ),
                      16.h,
                      Text('No orders yet', style: context.ts.titleMedium),
                      8.h,
                      Text(
                        'Start shopping to see your orders here',
                        style: context.ts.bodySmall?.copyWith(
                          color: context.cs.onSurface.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is OrdersPageLoaded) {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.orders.length,
                  separatorBuilder: (context, index) => 16.h,
                  itemBuilder: (context, index) {
                    return _OrderCard(order: state.orders[index]);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntities order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
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
                        color:
                            context.cs.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.inventory_2_outlined,
                          color: context.cs.primary),
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
                              color:
                                  context.cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const _StatusChip(),
                  ],
                ),
                16.h,
                Divider(
                    color: context.cs.outlineVariant.withValues(alpha: 0.2)),
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
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderStatusCubit, OrderStatusState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: state.color.withAlpha(26),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: state.color.withAlpha(128)),
          ),
          child: Text(
            state.label,
            style: context.ts.labelSmall?.copyWith(
              color: state.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
