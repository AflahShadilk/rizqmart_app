import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/user_profile_repository.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/checkout/checkout_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/checkout/checkout_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/payment/payment_selection_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/divider_ext.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/core/services/registeration/register.dart';

final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Customer';

Future<dynamic> modelBottomSheet(
  BuildContext context,
  CartLoadedState cartState,
) {
  final subtotal = cartState.totalAmount;
  final deliveryFee = 40.0;
  final discount = 0.0;
  final totalCost = subtotal + deliveryFee - discount;

  return showModalBottomSheet(
    elevation: 3,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (bottomSheetContext) {
      return BlocProvider(
        create: (context) => CheckoutCubit(),
        child: Container(
          decoration: BoxDecoration(
            color: context.cs.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: DraggableScrollableSheet(
            expand: false,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                shrinkWrap: true,
                children: [
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
                  8.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Colors.orange,
                            size: 18,
                          ),
                          8.w,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quick Delivery',
                                  style: context.ts.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                2.h,
                                Text(
                                  'Within 1 hour',
                                  style: context.ts.labelSmall?.copyWith(
                                    color: Colors.orange.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  8.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(0.3),
                  ),
                  8.h,
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, checkoutState) {
                      return checkoutRowCompact(
                        context,
                        icon: Icons.local_shipping_outlined,
                        title: 'Delivery',
                        trailing: checkoutState.deliveryMethod ?? 'Quick',
                        onTap: () {
                          context.read<CheckoutCubit>()
                              .setDeliveryMethod('Quick Delivery (Within 1 Hour)');
                        },
                      );
                    },
                  ),
                  4.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(0.3),
                  ),
                  4.h,
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, checkoutState) {
                      return checkoutRowCompact(
                        context,
                        icon: Icons.location_on_outlined,
                        title: 'Address',
                        trailing: checkoutState.deliveryAddress != null
                            ? _truncateAddress(checkoutState.deliveryAddress!)
                            : 'Select',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.selectAddress,
                            arguments: userId,
                          ).then((result) {
                            if (result != null) {
                              String addressToStore = '';

                              if (result is String) {
                                addressToStore = result;
                              } else if (result is AddressEntities) {
                                // Construct full address string
                                addressToStore = 
                                    '${result.fullName}, ${result.address1}, ${result.address2}, ${result.city}, ${result.state} - ${result.pincode}, Phone: ${result.phoneNumber}';
                              }

                              if (addressToStore.isNotEmpty) {
                                context.read<CheckoutCubit>().setDeliveryAddress(addressToStore);
                              }
                            }
                          });
                        },
                      );
                    },
                  ),
                  4.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(0.3),
                  ),
                  4.h,
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, checkoutState) {
                      return checkoutRowCompact(
                        context,
                        icon: Icons.payments_rounded,
                        title: 'Payment',
                        trailing: checkoutState.paymentMethod ?? 'Select',
                        onTap: () => _showPaymentMethodDialog(context),
                      );
                    },
                  ),
                  4.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(0.3),
                  ),
                  4.h,
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, checkoutState) {
                      return checkoutRowCompact(
                        context,
                        icon: Icons.local_offer_outlined,
                        title: 'Promo',
                        trailing: checkoutState.promoCode ?? 'Add',
                        onTap: () {},
                      );
                    },
                  ),
                  8.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(.3),
                  ),
                  8.h,
                  _costRowCompact(context, 'Subtotal', subtotal),
                  6.h,
                  _costRowCompact(context, 'Delivery', deliveryFee),
                  if (discount > 0) ...[
                    6.h,
                    _costRowCompact(context, 'Discount', -discount,
                        isDiscount: true),
                  ],
                  6.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withOpacity(.3),
                  ),
                  6.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: context.ts.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${totalCost.toStringAsFixed(2)}',
                        style: context.ts.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.cs.primary,
                        ),
                      ),
                    ],
                  ),
                  12.h,
                  Text(
                    'By placing an order you agree to our Terms and Conditions',
                    style: context.ts.labelSmall?.copyWith(
                      color: context.cs.onSurface.withOpacity(0.5),
                    ),
                  ),
                  12.h,
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, checkoutState) {
                      final canProceed = checkoutState.deliveryMethod != null &&
                          checkoutState.deliveryAddress != null &&
                          checkoutState.paymentMethod != null;

                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: MainButton(
                          label: canProceed
                              ? 'Place Order  ₹${totalCost.toStringAsFixed(2)}'
                              : 'Complete all fields',
                          onPress: canProceed
                              ? () async {
                                  // Fetch user profile data
                                  try {
                                    // Default values from Auth
                                    String userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Customer';
                                    String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'no-email@example.com';
                                    String userPhone = 'N/A';
                                    
                                    // Try to fetch from repository using sl
                                    try {
                                      final userProfileRepo = sl<UserProfileRepository>();
                                      final userProfile = await userProfileRepo.getUserProfile(userId);
                                      
                                      // Update with profile data if available
                                      if (userProfile.name.isNotEmpty) userName = userProfile.name;
                                      if (userProfile.email.isNotEmpty) userEmail = userProfile.email;
                                      userPhone = userProfile.phoneNumber ?? 'N/A';
                                      
                                    } catch (e) {
                                      debugPrint('Could not fetch user profile: $e');
                                    }

                                    final order = OrderEntities(
                                      orderId: '',
                                      userId: userId,
                                      items: cartState.items,
                                      subtotal: subtotal,
                                      deliveryFee: deliveryFee,
                                      discount: discount,
                                      totalCost: totalCost,
                                      deliveryMethod:
                                          checkoutState.deliveryMethod!,
                                      paymentMethod:
                                          checkoutState.paymentMethod!,
                                      promoCode: checkoutState.promoCode,
                                      status: 'pending_payment',
                                      createdAt: DateTime.now(),
                                      deliveryAddress:
                                          checkoutState.deliveryAddress!,
                                      // Fetch from user profile or Firebase Auth
                                      userName: userName,
                                      userEmail: userEmail,
                                      userPhone: userPhone,
                                      deliveryNotes: checkoutState.deliveryNotes,
                                    );

                                    Navigator.pop(bottomSheetContext);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) =>
                                            PaymentSelectionPage(order: order),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error placing order: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              : null,
                          color: context.cs.success,
                          textColor: context.cs.surface,
                        ),
                      );
                    },
                  ),
                  8.h,
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

String _truncateAddress(String address) {
  return address.length > 20
      ? '${address.substring(0, 20)}...'
      : address;
}

Widget checkoutRowCompact(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String trailing,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: context.cs.primary, size: 18),
          const SizedBox(width: 8),
          Text(title, style: context.ts.bodyMedium),
          const Spacer(),
          Text(trailing, style: context.ts.bodySmall),
          const SizedBox(width: 6),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: context.cs.onSurface.withOpacity(0.4),
          ),
        ],
      ),
    ),
  );
}

Widget _costRowCompact(
  BuildContext context,
  String label,
  double amount, {
  bool isDiscount = false,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: context.ts.bodySmall,
      ),
      Text(
        '${isDiscount ? '-' : ''}₹${amount.abs().toStringAsFixed(2)}',
        style: context.ts.bodySmall?.copyWith(
          color: isDiscount ? context.cs.success : context.cs.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

void _showPaymentMethodDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'Payment Method',
        style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _paymentOptionCompact(
            context,
            title: 'Cash on Delivery',
            subtitle: 'Pay on delivery',
            value: 'cod',
            icon: Icons.money,
          ),
          12.h,
          _paymentOptionCompact(
            context,
            title: 'Stripe',
            subtitle: 'Secure online payment',
            value: 'stripe',
            icon: Icons.credit_card,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

Widget _paymentOptionCompact(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String value,
  required IconData icon,
}) {
  return InkWell(
    onTap: () {
      context.read<CheckoutCubit>().setPaymentMethod(value);
      Navigator.pop(context);
    },
    borderRadius: BorderRadius.circular(8),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.cs.outlineVariant,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.cs.primary,
            size: 22,
          ),
          10.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.ts.bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                2.h,
                Text(
                  subtitle,
                  style: context.ts.labelSmall?.copyWith(
                    color: context.cs.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}