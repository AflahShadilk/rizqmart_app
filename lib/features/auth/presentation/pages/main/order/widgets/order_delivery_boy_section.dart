import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/delivery/delivery_partner_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/delivery/delivery_partner_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/chat/chat_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Order Delivery Boy Section ----------------

class OrderDeliveryBoySection extends StatelessWidget {
  // ---------------- Variables ----------------
  final OrderEntities order;

  // ---------------- Constructor ----------------
  const OrderDeliveryBoySection({super.key, required this.order});

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

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
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
                    child: Text(
                      state.name[0],
                      style: TextStyle(
                        color: context.cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  12.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.name,
                          style: context.ts.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
}
