// ignore_for_file: use_build_context_synchronously

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
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/checkout/checkout_calculation_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/checkout/checkout_calculation_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/payment/payment_selection_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/divider_ext.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/apply_coupon_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/apply_coupon_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_engine.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';

final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'Customer';

Future<dynamic> modelBottomSheet(
  BuildContext context,
  CartLoadedState cartState,
) {
  return showModalBottomSheet(
    elevation: 3,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (bottomSheetContext) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CheckoutCubit()),
          BlocProvider(
            create: (_) => CheckoutCalculationCubit()
              ..calculate(cartState.items),
          ),
          BlocProvider(create: (_) => ApplyCouponCubit()),
        ],
        child: Container(
          decoration: BoxDecoration(
            color: context.cs.surface,
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
                    color: context.cs.outlineVariant.withValues(alpha: 0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
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
                                    color: Colors.orange.withValues(alpha: 0.8),
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
                    color: context.cs.outlineVariant.withValues(alpha: 0.3),
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
                    color: context.cs.outlineVariant.withValues(alpha: 0.3),
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
                    color: context.cs.outlineVariant.withValues(alpha: 0.3),
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
                    color: context.cs.outlineVariant.withValues(alpha: 0.3),
                  ),
                  4.h,
                  BlocBuilder<ApplyCouponCubit, ApplyCouponState>(
                    builder: (context, couponState) {
                      return checkoutRowCompact(
                        context,
                        icon: Icons.local_offer_outlined,
                        title: 'Promo Code',
                        trailing: couponState.hasCoupon
                            ? couponState.appliedCoupon!.name
                            : 'Select',
                        onTap: () => _showCouponSelectionDialog(context, cartState),
                      );
                    },
                  ),
                  8.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withValues(alpha: .3),
                  ),
                  8.h,
                  BlocBuilder<CheckoutCalculationCubit, CheckoutCalculationState>(
                    builder: (context, calcState) {
                      return Column(
                        children: [
                          _costRowCompact(context, 'Subtotal (MRP)', calcState.totalMrp),
                          6.h,
                          _costRowCompact(context, 'Delivery', calcState.deliveryFee),
                          if (calcState.totalSavings > 0) ...[
                            6.h,
                            _costRowCompact(context, 'Discount', -calcState.totalSavings,
                                isDiscount: true),
                          ],
                          if (calcState.couponDiscount > 0) ...[
                            6.h,
                            _costRowCompact(context, 'Coupon Discount', -calcState.couponDiscount,
                                isDiscount: true),
                          ],
                        ],
                      );
                    },
                  ),
                  6.h,
                  context.divider(
                    thickness: 1,
                    color: context.cs.outlineVariant.withValues(alpha: .3),
                  ),
                  6.h,
                  BlocBuilder<CheckoutCalculationCubit, CheckoutCalculationState>(
                    builder: (context, calcState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: context.ts.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${calcState.totalCost.toStringAsFixed(2)}',
                            style: context.ts.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.cs.primary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  12.h,
                  Text(
                    'By placing an order you agree to our Terms and Conditions',
                    style: context.ts.labelSmall?.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  12.h,
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    builder: (context, checkoutState) {
                      final canProceed = checkoutState.deliveryMethod != null &&
                          checkoutState.deliveryAddress != null &&
                          checkoutState.paymentMethod != null;

                      return BlocBuilder<CheckoutCalculationCubit, CheckoutCalculationState>(
                        builder: (context, calcState) {
                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: MainButton(
                              label: canProceed
                                  ? 'Place Order  ₹${calcState.totalCost.toStringAsFixed(2)}'
                                  : 'Complete all fields',
                              onPress: canProceed
                                  ? () async {
                                      try {
                                        String orderUserName = FirebaseAuth.instance.currentUser?.displayName ?? 'Customer';
                                        String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'no-email@example.com';
                                        String userPhone = 'N/A';

                                        try {
                                          final userProfileRepo = sl<UserProfileRepository>();
                                          final userProfile = await userProfileRepo.getUserProfile(userId);
                                          if (userProfile.name.isNotEmpty) orderUserName = userProfile.name;
                                          if (userProfile.email.isNotEmpty) userEmail = userProfile.email;
                                          userPhone = userProfile.phoneNumber ?? 'N/A';
                                        } catch (_) {}

                                        final applyCouponState = context.read<ApplyCouponCubit>().state;
                                        final latestCalcState = context.read<CheckoutCalculationCubit>().state;

                                        final order = OrderEntities(
                                          orderId: '',
                                          userId: userId,
                                          items: cartState.items,
                                          subtotal: latestCalcState.subtotal,
                                          deliveryFee: latestCalcState.deliveryFee,
                                          discount: latestCalcState.totalSavings + latestCalcState.couponDiscount,
                                          totalCost: latestCalcState.totalCost,
                                          deliveryMethod: checkoutState.deliveryMethod!,
                                          paymentMethod: checkoutState.paymentMethod!,
                                          promoCode: applyCouponState.appliedCoupon?.name,
                                          status: 'pending_payment',
                                          createdAt: DateTime.now(),
                                          deliveryAddress: checkoutState.deliveryAddress!,
                                          userName: orderUserName,
                                          userEmail: userEmail,
                                          userPhone: userPhone,
                                          deliveryNotes: checkoutState.deliveryNotes,
                                          couponId: applyCouponState.appliedCoupon?.id,
                                          couponName: applyCouponState.appliedCoupon?.name,
                                          discountAmount: applyCouponState.discount,
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
          8.w,
          Text(title, style: context.ts.bodyMedium),
          const Spacer(),
          Text(trailing, style: context.ts.bodySmall),
          6.w,
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: context.cs.onSurface.withValues(alpha: 0.4),
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
      Text(label, style: context.ts.bodySmall),
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
          Icon(icon, color: context.cs.primary, size: 22),
          10.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.ts.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                2.h,
                Text(
                  subtitle,
                  style: context.ts.labelSmall?.copyWith(
                    color: context.cs.onSurface.withValues(alpha: 0.6),
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

void _showCouponSelectionDialog(BuildContext context, CartLoadedState cartState) {
  final applyCouponCubit = context.read<ApplyCouponCubit>();
  final calcCubit = context.read<CheckoutCalculationCubit>();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'Available Offers',
        style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: BlocBuilder<AvailableCouponCubit, AvailableCouponState>(
        builder: (dialogContext, couponState) {
          if (couponState is AvailableCouponLoading) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (couponState is AvailableCouponLoaded) {
            if (couponState.coupons.isEmpty) {
              return const Text('No offers available at the moment.');
            }
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: couponState.coupons.length + 1,
                itemBuilder: (_, index) {
                  if (index == couponState.coupons.length) {
                    return ListTile(
                      leading: Icon(Icons.close, color: context.cs.error),
                      title: const Text('Remove Coupon'),
                      onTap: () {
                        applyCouponCubit.removeCoupon();
                        calcCubit.calculate(cartState.items);
                        Navigator.pop(ctx);
                      },
                    );
                  }
                  final coupon = couponState.coupons[index];
                  final validationError = CouponEngine.validateCoupon(coupon, cartState.items);
                  final isApplicable = validationError == null;

                  final discountText = coupon.percentage > 0
                      ? '${coupon.percentage.toStringAsFixed(0)}% OFF'
                      : '₹${coupon.amount.toStringAsFixed(0)} OFF';

                  return Opacity(
                    opacity: isApplicable ? 1.0 : 0.5,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isApplicable
                              ? Colors.orange.withValues(alpha: 0.4)
                              : context.cs.outlineVariant.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: isApplicable
                            ? () {
                                final deliveryFee = calcCubit.state.deliveryFee;
                                applyCouponCubit.applyCoupon(
                                  coupon,
                                  cartState.items,
                                  deliveryFee,
                                );
                                calcCubit.calculate(
                                  cartState.items,
                                  coupon: coupon,
                                );
                                Navigator.pop(ctx);
                              }
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: coupon.imageurl.isNotEmpty
                                      ? ProductImage(
                                          imageUrl: coupon.imageurl,
                                          width: 50,
                                          height: 50,
                                        )
                                      : Container(
                                          color: Colors.orange.withValues(alpha: 0.1),
                                          child: const Icon(
                                            Icons.local_offer,
                                            color: Colors.orange,
                                            size: 24,
                                          ),
                                        ),
                                ),
                              ),
                              10.w,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coupon.name,
                                      style: context.ts.bodySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    2.h,
                                    Text(
                                      discountText,
                                      style: context.ts.labelMedium?.copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    2.h,
                                    Text(
                                      isApplicable
                                          ? 'Min. order ₹${coupon.minOrderValue.toStringAsFixed(0)}'
                                          : validationError,
                                      style: context.ts.labelSmall?.copyWith(
                                        color: isApplicable
                                            ? context.cs.onSurface.withValues(alpha: 0.5)
                                            : context.cs.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isApplicable)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.cs.success.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: context.cs.success.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    'Apply',
                                    style: context.ts.labelSmall?.copyWith(
                                      color: context.cs.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
