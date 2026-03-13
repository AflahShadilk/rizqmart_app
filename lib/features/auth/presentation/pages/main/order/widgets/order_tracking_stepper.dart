import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20Tracking/order_tracking_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20Tracking/order_tracking_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class OrderTrackingStepper extends StatelessWidget {
static const List<String> steps = ['Placed', 'Processing', 'Shipped', 'Out', 'Delivered'];
const OrderTrackingStepper({super.key});
@override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
      builder: (context, state) {
        if (state is OrderTrackingCancelled) {
          return Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(26), // Keep custom error shade as per existing behavior, or replace with AppColors.error500 if requested system-wide, but sticking to existing Colors.red for exact replica
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withAlpha(77)),
            ),
            child: Center(
              child: Text(
                'ORDER CANCELLED',
                style: context.ts.titleMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        final int currentStep = (state as OrderTrackingActive).currentStep;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track Order',
              style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            16.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(steps.length, (index) {
                final bool isCompleted = index <= currentStep;
                final bool isLast = index == steps.length - 1;

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
                                width: 2,
                              ),
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
                          fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                        ),
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
}
