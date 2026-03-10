import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20status/order_status_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20status/order_status_state.dart';

// ---------------- Order Status Chip ----------------

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key});

  // ---------------- Build Method ----------------
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
