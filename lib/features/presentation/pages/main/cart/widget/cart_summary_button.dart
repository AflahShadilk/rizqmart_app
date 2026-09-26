import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/presentation/pages/main/order/show_order_files.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/reusable_main_button.dart';

/// A checkout summary button displaying the total amount and navigating to the order flow.
class CartSummaryButton extends StatelessWidget {

  // ---------------- Variables ----------------

  final CartLoadedState state;

  const CartSummaryButton({super.key, required this.state});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      height: 50,
      child: MainButton(
        label: 'Go to Checkout   ₹${state.totalAmount.toStringAsFixed(2)}',
        onPress: () {
          modelBottomSheet(context, state);
        },
        color: context.cs.success,
        textColor: context.cs.surface,
      ),
    );
  }
}
