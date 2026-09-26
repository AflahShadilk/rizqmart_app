// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/presentation/cubits/delivery/delivery_partner_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/order/invoice/invoice_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/order/order%20Tracking/order_tracking_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/order/order%20cancel/order_cancel_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/order/order%20cancel/order_cancel_state.dart';
import 'package:rizqmart/features/presentation/cubits/order/support/support_cubit.dart';
import 'package:rizqmart/features/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/order/order_event.dart';
import 'package:rizqmart/features/presentation/bloc/main/order/order_state.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/presentation/pages/main/order/widgets/order_header.dart';
import 'package:rizqmart/features/presentation/pages/main/order/widgets/order_tracking_stepper.dart';
import 'package:rizqmart/features/presentation/pages/main/order/widgets/order_delivery_boy_section.dart';
import 'package:rizqmart/features/presentation/pages/main/order/widgets/order_products_list.dart';
import 'package:rizqmart/features/presentation/pages/main/order/widgets/order_summary_section.dart';
import 'package:rizqmart/features/presentation/pages/main/order/widgets/order_action_buttons.dart';

// ---------------- Order Details Page ----------------

/// A comprehensive page showing tracking status, delivery details, and items for a specific order.
class OrderDetailsPage extends StatelessWidget {
  // ---------------- Variables ----------------
  final OrderEntities order;

  // ---------------- Constructor ----------------
  const OrderDetailsPage({super.key, required this.order});

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DeliveryPartnerCubit()),
        BlocProvider(create: (_) => OrderTrackingCubit(order.status)),
        BlocProvider(create: (_) => InvoiceCubit()),
        BlocProvider(create: (_) => SupportCubit()),
        BlocProvider(
          create: (ctx) => OrderCancelCubit(
            orderBloc: ctx.read<OrderBloc>(),
          ),
        ),
      ],
      child: _OrderDetailsView(order: order),
    );
  }
}

// ---------------- Order Details View ----------------

class _OrderDetailsView extends StatefulWidget {
  // ---------------- Variables ----------------
  final OrderEntities order;

  // ---------------- Constructor ----------------
  const _OrderDetailsView({required this.order});

  @override
  State<_OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<_OrderDetailsView> {
  late OrderEntities currentOrder;

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
  }

  // ---------------- Helper Methods ----------------
  void _onOrderCancelStateChange(BuildContext context, OrderCancelState state) {
    if (state is OrderCancelSuccess) {
      Navigator.pop(context);
    }
  }

  void _onOrderBlocStateChange(BuildContext context, OrderState state) {
    if (state is OrdersLoadedState) {
      try {
        final updatedOrder = state.orders.firstWhere((o) => o.orderId == currentOrder.orderId);
        setState(() {
          currentOrder = updatedOrder;
        });
        context.read<OrderTrackingCubit>().updateStatus(updatedOrder.status);
      } catch (_) {
        // Order not found or not in list
      }
    }
  }

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrderCancelCubit, OrderCancelState>(
          listener: _onOrderCancelStateChange,
        ),
        BlocListener<OrderBloc, OrderState>(
          listener: _onOrderBlocStateChange,
        ),
      ],
      child: ResponsiveWrapper(
        child: Scaffold(
          backgroundColor: context.cs.surface,
          
          // ---------------- Order Details Header ----------------
          appBar: AppBar(
            title: Text(
              'Order Details',
              style: context.ts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: context.cs.surface,
            elevation: 0,
          ),
          
          // ---------------- Order Details Body ----------------
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<OrderBloc>().add(const GetUserOrdersEvent());
              await Future.delayed(const Duration(seconds: 1));
            },
            color: context.cs.primary,
            backgroundColor: context.cs.surface,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderHeader(order: currentOrder),
                    24.h,
                    const OrderTrackingStepper(),
                    24.h,
                    OrderDeliveryBoySection(order: currentOrder),
                    24.h,
                    OrderProductsList(order: currentOrder),
                    24.h,
                    OrderSummarySection(order: currentOrder),
                    32.h,
                    OrderActionButtons(order: currentOrder),
                    40.h,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
