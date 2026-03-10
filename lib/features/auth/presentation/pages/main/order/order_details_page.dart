// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/delivery/delivery_partner_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/invoice/invoice_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20Tracking/order_tracking_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20cancel/order_cancel_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20cancel/order_cancel_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/support/support_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_header.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_tracking_stepper.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_delivery_boy_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_products_list.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_summary_section.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_action_buttons.dart';

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

class _OrderDetailsView extends StatelessWidget {
  // ---------------- Variables ----------------
  final OrderEntities order;

  // ---------------- Constructor ----------------
  const _OrderDetailsView({required this.order});

  // ---------------- Helper Methods ----------------
  void _onOrderCancelStateChange(BuildContext context, OrderCancelState state) {
    if (state is OrderCancelSuccess) {
      Navigator.pop(context);
    }
  }

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCancelCubit, OrderCancelState>(
      listener: _onOrderCancelStateChange,
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderHeader(order: order),
                  24.h,
                  const OrderTrackingStepper(),
                  24.h,
                  OrderDeliveryBoySection(order: order),
                  24.h,
                  OrderProductsList(order: order),
                  24.h,
                  OrderSummarySection(order: order),
                  32.h,
                  OrderActionButtons(order: order),
                  40.h,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}