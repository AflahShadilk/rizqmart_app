// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/presentation/pages/main/cart/widget/cart_empty_state.dart';
import 'package:rizqmart/features/presentation/pages/main/cart/widget/cart_item_card.dart';
import 'package:rizqmart/features/presentation/pages/main/cart/widget/cart_summary_button.dart';
import 'package:rizqmart/features/presentation/widgets/bloc%20helper/circular_progress.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/presentation/widgets/common/show_toast_actions.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

/// A page widget that displays the user's active shopping cart, item list, and order total.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CartBloc>().add(const GetCartItemsEvent());
    });
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(child: Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        title: const AppHeading('My Cart'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartErrorState) {
            showToast(context, state.message, type: ToastType.error);
          }
          if (state is CartSuccessState) {
            showToast(context, state.messaage, type: ToastType.success);
          }
        },
        builder: (context, state) {
          // ---------------- Loading State ----------------
          if (state is CartLoadingState) {
            return const CustomCircularProgressIndicator();
          }

          // ---------------- Empty Cart State ----------------
          if (state is CartEmptyState) {
            return const CartEmptyView();
          }

          // ---------------- Loaded Cart State ----------------
          if (state is CartLoadedState) {
            return Column(
              children: [
                // ---------------- Cart Items List ----------------
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CartItemCard(cartItem: item),
                      );
                    },
                  ),
                ),
                // ---------------- Checkout Summary ----------------
                CartSummaryButton(state: state),
                10.h
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    ));
  }
}