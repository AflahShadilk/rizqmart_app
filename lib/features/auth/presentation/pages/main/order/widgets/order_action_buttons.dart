import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/invoice/invoice_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/invoice/invoice_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20cancel/order_cancel_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/support/support_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/chat/chat_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Order Action Buttons ----------------

class OrderActionButtons extends StatelessWidget {
  // ---------------- Variables ----------------
  final OrderEntities order;

  // ---------------- Constructor ----------------
  const OrderActionButtons({super.key, required this.order});

  // ---------------- Helper Methods ----------------
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
          'Are you sure you want to cancel this order? This action cannot be undone and the amount will be refunded to your wallet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<OrderCancelCubit>().confirmCancel(order.orderId);
            },
            child: Text('Yes, Cancel', style: TextStyle(color: context.cs.error)),
          ),
        ],
      ),
    );
  }

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    final bool isCancelled = order.status.toLowerCase() == 'cancelled';
    final bool isDelivered = order.status.toLowerCase() == 'delivered';

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
                    side: BorderSide(color: context.cs.error),
                    foregroundColor: context.cs.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Cancel Order',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                        color: context.cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
