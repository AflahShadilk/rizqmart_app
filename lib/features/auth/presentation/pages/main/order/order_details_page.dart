// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/delivery/delivery_partner_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/delivery/delivery_partner_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/invoice/invoice_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/invoice/invoice_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20Tracking/order_tracking_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20Tracking/order_tracking_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20cancel/order_cancel_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20cancel/order_cancel_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/support/support_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/chat/chat_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderEntities order;

  const OrderDetailsPage({super.key, required this.order});

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

class _OrderDetailsView extends StatelessWidget {
  final OrderEntities order;

  const _OrderDetailsView({required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCancelCubit, OrderCancelState>(
      listener: (context, state) {
        if (state is OrderCancelSuccess) {
          Navigator.pop(context);
        }
      },
      child: ResponsiveWrapper(
        child: Scaffold(
          backgroundColor: context.cs.surface,
          appBar: AppBar(
            title: Text(
              'Order Details',
              style: context.ts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: context.cs.surface,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderHeader(context),
                  24.h,
                  _buildTrackingStepper(context),
                  24.h,
                  _buildDeliveryBoySection(context),
                  24.h,
                  _buildOrderItemsList(context),
                  24.h,
                  _buildOrderSummary(context),
                  32.h,
                  _buildActionButtons(context),
                  40.h,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
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
                '#${order.orderId.substring(0, 8).toUpperCase()}',
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
                DateFormat('dd MMM, yyyy').format(order.createdAt),
                style: context.ts.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStepper(BuildContext context) {
    return BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
      builder: (context, state) {
        if (state is OrderTrackingCancelled) {
          return Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withAlpha(77)),
            ),
            child: Center(
              child: Text(
                'ORDER CANCELLED',
                style: context.ts.titleMedium
                    ?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        final currentStep = (state as OrderTrackingActive).currentStep;
        final steps = ['Placed', 'Processing', 'Shipped', 'Out', 'Delivered'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Track Order',
                style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            16.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(steps.length, (index) {
                final isCompleted = index <= currentStep;
                final isLast = index == steps.length - 1;

                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: index == 0
                                  ? Colors.transparent
                                  : (index <= currentStep
                                      ? context.cs.primary
                                      : context.cs.outlineVariant),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isCompleted ? context.cs.primary : context.cs.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: isCompleted
                                      ? context.cs.primary
                                      : context.cs.outlineVariant,
                                  width: 2),
                            ),
                            child: isCompleted
                                ? Icon(Icons.check, size: 14, color: context.cs.surface)
                                : null,
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: isLast
                                  ? Colors.transparent
                                  : (index < currentStep
                                      ? context.cs.primary
                                      : context.cs.outlineVariant),
                            ),
                          ),
                        ],
                      ),
                      8.h,
                      Text(
                        steps[index],
                        style: context.ts.labelSmall?.copyWith(
                            color: isCompleted
                                ? context.cs.primary
                                : context.cs.onSurface.withAlpha(128),
                            fontWeight:
                                isCompleted ? FontWeight.bold : FontWeight.normal),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeliveryBoySection(BuildContext context) {
    if (order.status.toLowerCase() == 'pending' ||
        order.status.toLowerCase() == 'cancelled') {
      return const SizedBox.shrink();
    }

    return BlocBuilder<DeliveryPartnerCubit, DeliveryPartnerState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Partner',
                style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            12.h,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.cs.surfaceContainerHighest.withAlpha(77),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.cs.outlineVariant.withAlpha(128)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: context.cs.primary.withAlpha(26),
                    child: Text(state.name[0],
                        style: TextStyle(
                            color: context.cs.primary, fontWeight: FontWeight.bold)),
                  ),
                  12.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.name,
                            style: context.ts.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('RizqMaster Partner • 4.8 ★', style: context.ts.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _navigateToChat(context),
                    icon: const Icon(Icons.chat_bubble_outline, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: context.cs.primary,
                      foregroundColor: context.cs.surface,
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderItemsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Items',
            style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        12.h,
        ...order.items.map((item) {
          String? imageUrl;
          List<String> details = [];
          double unitPrice = 0.0;

          if (item.variantDetails.isNotEmpty &&
              item.variantIndex < item.variantDetails.length) {
            final variant = item.variantDetails[item.variantIndex];

            final imageUrlsRaw = variant['imageUrls'];
            if (imageUrlsRaw is List) {
              final firstUrl = (imageUrlsRaw as List)
                  .map((e) => e?.toString() ?? '')
                  .firstWhere((e) => e.isNotEmpty, orElse: () => '');
              if (firstUrl.isNotEmpty) imageUrl = firstUrl;
            }

            final priceRaw = variant['mrp'];
            if (priceRaw != null) {
              unitPrice = (priceRaw as num).toDouble();
            }

            final unitName = variant['unitName']?.toString() ?? '';
            if (unitName.isNotEmpty) details.add(unitName);
          }

          final double totalPrice = unitPrice * item.count;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImage(
                  imageUrl: imageUrl,
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(8),
                ),
                12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: context.ts.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      4.h,
                      if (details.isNotEmpty)
                        Text(
                          '${item.count}x  •  ${details.join(", ")}',
                          style: context.ts.bodySmall,
                        )
                      else
                        Text('${item.count}x', style: context.ts.bodySmall),
                    ],
                  ),
                ),
                8.w,
                Text(
                  '₹${totalPrice.toStringAsFixed(2)}',
                  style: context.ts.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary',
            style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
            Text('Total Amount',
                style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text(
              '₹${order.totalCost.toStringAsFixed(2)}',
              style: context.ts.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold, color: context.cs.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow(BuildContext context, String label, double amount,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.ts.bodyMedium),
        Text(
          '${isDiscount ? "-" : ""}₹${amount.abs().toStringAsFixed(2)}',
          style: context.ts.bodyMedium?.copyWith(
              color: isDiscount ? Colors.green : context.cs.onSurface,
              fontWeight: isDiscount ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isCancelled = order.status.toLowerCase() == 'cancelled';
    final isDelivered = order.status.toLowerCase() == 'delivered';

    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, invoiceState) {
        return Column(
          children: [
            if (!isCancelled && !isDelivered)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showCancelDialog(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Cancel Order',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            if (!isCancelled && !isDelivered) 16.h,
            SizedBox(
              width: double.infinity,
              child: MainButton(
                label: invoiceState is InvoiceLoading
                    ? 'Generating...'
                    : 'Download Invoice',
                onPress: invoiceState is InvoiceLoading
                    ? null
                    : () => context.read<InvoiceCubit>().generateAndPrint(order),
                color: context.cs.primary,
                textColor: context.cs.onPrimary,
                icon: invoiceState is InvoiceLoading ? null : Icons.download_rounded,
              ),
            ),
            16.h,
            InkWell(
              onTap: () =>
                  context.read<SupportCubit>().launchSupportEmail(order.orderId),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.headset_mic_outlined,
                        size: 20, color: context.cs.primary),
                    8.w,
                    Text(
                      'Need Help? Contact Support',
                      style: context.ts.bodyMedium?.copyWith(
                          color: context.cs.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            16.h,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _navigateToChat(context),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Chat with Seller'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: context.cs.primary),
                  foregroundColor: context.cs.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          orderId: order.orderId,
          orderDisplayId: order.orderId.substring(0, 8).toUpperCase(),
          deliveryPartnerName: 'RizqMart Support',
          orderStatus: order.status,
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: const Text(
            'Are you sure you want to cancel this order? This action cannot be undone and the amount will be refunded to your wallet.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('No')),
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<OrderCancelCubit>().confirmCancel(order.orderId);
              },
              child: const Text('Yes, Cancel',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}