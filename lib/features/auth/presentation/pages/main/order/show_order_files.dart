
// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/error_order.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/success_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/cart/widget/cart_widgets.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/divider_ext.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
Future<dynamic> modelBottomSheet(
  BuildContext context,
  CartLoadedState cartState,
) {
  final subtotal = cartState.totalAmount;
  final deliveryFee = 40.0;
  final discount = 0.0;
  final totalCost = subtotal + deliveryFee - discount;

  String? selectedDeliveryMethod;
  String? selectedPaymentMethod;
  String? selectedPromoCode;

  return showModalBottomSheet(
    elevation: 3,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (bottomSheetContext) {
      return BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccessState) {
            context.read<CartBloc>().add(const ClearCartEvent());

            Navigator.pop(bottomSheetContext);
            Navigator.of(bottomSheetContext).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SuccessPage(),
              ),
            );
          }
          if (state is OrderErrorState) {
            Navigator.pop(bottomSheetContext);
            orderErrorDialog(bottomSheetContext, state.message);
          }
        },
        builder: (context, orderState) {
          final isLoading = orderState is OrderLoadingState;

          return Container(
            decoration: BoxDecoration(
              color: context.cs.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Checkout',
                        style: context.ts.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(bottomSheetContext),
                        icon: Icon(
                          Icons.close,
                          color: context.cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                  16.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(0.3),
                  ),
                  5.h,

                  // Delivery Method
                  checkoutRow(
                    context,
                    icon: Icons.local_shipping_outlined,
                    title: 'Delivery',
                    trailing: selectedDeliveryMethod ?? 'Select method',
                    onTap: () {
                       Navigator.pushNamed(
            context,
            AppRoutes.userAddress,
            arguments: userId,
          );
                    },
                  ),
                  5.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(0.3),
                  ),
                  5.h,

                  // Payment Method
                  checkoutRow(
                    context,
                    icon: Icons.payments_rounded,
                    title: 'Payment',
                    trailing: selectedPaymentMethod ?? 'Select method',
                    onTap: () {
                      // Show payment method
                    },
                  ),
                  5.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(0.3),
                  ),
                  5.h,

                  // Promo Code
                  checkoutRow(
                    context,
                    icon: Icons.local_offer_outlined,
                    title: 'Promo Code',
                    trailing: selectedPromoCode ?? 'Pick discount',
                    onTap: () {
                      // Show promo code
                    },
                  ),
                  5.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(.3),
                  ),
                  16.h,

                  // Cost managment
                  costRow(context, 'Subtotal', subtotal),
                  8.h,
                  costRow(context, 'Delivery Fee', deliveryFee),
                  if (discount > 0) ...[
                    8.h,
                    costRow(context, 'Discount', -discount, isDiscount: true),
                  ],
                  8.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(.3),
                  ),
                  8.h,

                  // Total Cost
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Cost',
                        style: context.ts.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${totalCost.toStringAsFixed(2)}',
                        style: context.ts.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.cs.primary,
                        ),
                      ),
                    ],
                  ),
                  16.h,

                  // Terms and Conditions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By placing an order you agree to our',
                        style: context.ts.labelSmall?.copyWith(
                          color: context.cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Terms and Conditions',
                          style: context.ts.labelSmall?.copyWith(
                            color: context.cs.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.h,

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: MainButton(
                      label: isLoading
                          ? 'Processing...'
                          : 'Place Order  ₹${totalCost.toStringAsFixed(2)}',
                      onPress: isLoading
                          ? null
                          : () {
                              final order = OrderEntities(
                                orderId: '',
                                userId: '',
                                items: cartState.items,
                                subtotal: subtotal,
                                deliveryFee: deliveryFee,
                                discount: discount,
                                totalCost: totalCost,
                                deliveryMethod: selectedDeliveryMethod ??
                                    'Standard Delivery',
                                paymentMethod:
                                    selectedPaymentMethod ?? 'Cash on Delivery',
                                promoCode: selectedPromoCode,
                                status: 'pending',
                                createdAt: DateTime.now(),
                                deliveryAddress: 'User Address Here okkkkk',
                              );

                              context
                                  .read<OrderBloc>()
                                  .add(PlaceOrderEvent(order));
                            },
                      color: context.cs.success,
                      textColor: context.cs.surface,
                    ),
                  ),
                  10.h,
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
