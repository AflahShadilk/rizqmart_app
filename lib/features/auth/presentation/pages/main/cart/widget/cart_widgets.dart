// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/cart/success_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/navigator/navigation_bar.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/divider_ext.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/reusable_text.dart';

//Empty cart
Widget emptyCart(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_cart_outlined,
          size: 100,
          color: context.cs.onSurface.withOpacity(.3),
        ),
        16.h,
        ReusableText(
          texts: 'Your cart is empty',
          titleSize: context.ts.titleLarge?.copyWith(
            color: context.cs.onSurface.withOpacity(0.6),
          ),
        ),
        8.h,
        ReusableText(
          texts: 'Add items to get started',
          titleSize: context.ts.bodyMedium?.copyWith(
            color: context.cs.onSurface.withOpacity(0.4),
          ),
        ),
      ],
    ),
  );
}

//main product card
class ProductContainer extends StatelessWidget {
  const ProductContainer({super.key, required this.cartitems});
  final CartEntities cartitems;

  @override
  Widget build(BuildContext context) {
    final variant = cartitems.variantIndex < cartitems.variantDetails.length
        ? cartitems.variantDetails[cartitems.variantIndex]
        : null;

    // Set image
    String imageUrl = '';
    if (variant != null) {
      final imageUrls = variant['imageUrls'];
      if (imageUrls != null && imageUrls is List && imageUrls.isNotEmpty) {
        imageUrl = imageUrls[0].toString();
      }
    }

    final variantName = variant?['unitName'] ?? 'Unknown Variant';
    final price = (variant?['mrp'] ?? 0).toDouble();
    final cartItemId = '${cartitems.id}_variant_${cartitems.variantIndex}';
    final totalPrice = price * cartitems.count;

    return Dismissible(
      key: Key(cartItemId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showRemoveDialog(context, cartItemId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        decoration: const BoxDecoration(
          color: AppColors.error500,
        ),
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete_outline,
          color: context.cs.surface,
          size: 32,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.cs.surface,
          border: Border(
            bottom: BorderSide(
              color: context.cs.outlineVariant.withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ProductImage(
                imageUrl: imageUrl,
                height: 100,
                width: 100,
              ),
            ),
            12.w,
            // Product De tails
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name
                  Text(
                    cartitems.name,
                    style: context.ts.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.h,

                  // Variant Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        variantName,
                        style: context.ts.labelMedium?.copyWith(
                          color: context.cs.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  12.h,

                  // Quantity Counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      quantityCounter(context, cartItemId, cartitems.count),

                      // Total Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (cartitems.count > 1)
                            Text(
                              '${cartitems.count} × ₹${price.toStringAsFixed(2)}',
                              style: context.ts.labelSmall?.copyWith(
                                color: context.cs.secondary.withOpacity(0.6),
                              ),
                            ),
                          Text(
                            '₹${totalPrice.toStringAsFixed(2)}',
                            style: context.ts.titleMedium?.copyWith(
                              color: context.cs.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quantityCounter(BuildContext context, String cartItemId, int count) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.cs.primary.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement Button
          InkWell(
            onTap: () {
              if (count > 1) {
                context
                    .read<CartBloc>()
                    .add(DecrementQuantityEvent(cartItemId));
              }
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7),
              bottomLeft: Radius.circular(7),
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.remove,
                color: context.cs.error,
                size: 18,
              ),
            ),
          ),

          // Count Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: context.cs.onBackground,
              ),
            ),
          ),

          // Increment Button
          InkWell(
            onTap: () {
              context.read<CartBloc>().add(IncrementQuantityEvent(cartItemId));
            },
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(7),
              bottomRight: Radius.circular(7),
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.add,
                color: context.cs.success,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> showRemoveDialog(BuildContext context, String cartItemId) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Remove Item',
          style: context.ts.titleLarge,
        ),
        content: Text(
            'Are you sure you want to remove this item from your cart?',
            style: context.ts.bodyMedium
                ?.copyWith(color: context.cs.onSecondary.withOpacity(0.4))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancel',
              style: context.ts.labelMedium,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<CartBloc>().add(RemoveFromCartEvent(cartItemId));
              Navigator.pop(dialogContext, true);
            },
            child: Text(
              'Remove',
              style: context.ts.labelMedium?.copyWith(
                  color: context.cs.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// summery
Widget cardSummery(BuildContext context, CartLoadedState state) {
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
        textColor: context.cs.surface),
  );
}

// bottomsheet
Future<dynamic> modelBottomSheet(
    BuildContext context, CartLoadedState cartState) {
  // Calculation
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
    builder: (context) {
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
                    onPressed: () => Navigator.pop(context),
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
                trailing: 'Select method',
                onTap: () {},
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
                trailing: 'Select method',
                onTap: () {},
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
                trailing: 'Pick discount',
                onTap: () {},
              ),
              5.h,

              context.divider(
                thickness: 1,
                color: context.cs.outlineVariant.withOpacity(.3),
              ),
              16.h,

              // Cost Breakdown
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

              // Place Order Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: MainButton(
                  label: 'Place Order  ₹${totalCost.toStringAsFixed(2)}',
                  onPress: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SuccessPage()));
                    orderErrorDailog(context);
                  },
                  color: context.cs.success,
                  textColor: context.cs.surface,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<dynamic> orderErrorDailog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: context.cs.onSurface.withOpacity(0.6),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                Lottie.asset(
                  "assets/lottie/Shopping bag - error.json",
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                16.h,
                ReusableText(
                  texts: 'Oops! Order failed',
                  titleSize: context.ts.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.cs.error
                  ),
                ),
                8.h,
                ReusableText(
                  texts: 'Something went wrong',
                  titleSize: context.ts.bodyMedium?.copyWith(
                    color: context.cs.onSurface.withOpacity(0.5),
                  ),
                ),
                24.h,
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: MainButton(
                    label: 'Please try again',
                    onPress: () => Navigator.of(context).pop(),
                    color: context.cs.primary,
                    textColor: context.cs.surface,
                  ),
                ),
                12.h,
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>NavigationBarPage()));
                  },
                  child: Text(
                    'Back to Home',
                    style: context.ts.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                 
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

// checkout row
Widget checkoutRow(
  BuildContext context, {
  IconData? icon,
  required String title,
  required String trailing,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.cs.primary,
            size: 18,
          ),
          10.w,
          Text(
            title,
            style: context.ts.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.cs.onSurface.withOpacity(0.5)),
          ),
          const Spacer(),
          Text(
            trailing,
            style: context.ts.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          8.w,
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: context.cs.onSurface.withOpacity(0.4),
          ),
        ],
      ),
    ),
  );
}

// cost row
Widget costRow(
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
        style: context.ts.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
      Text(
        '${isDiscount ? '-' : ''}₹${amount.abs().toStringAsFixed(2)}',
        style: context.ts.bodyLarge?.copyWith(
          color: isDiscount ? context.cs.success : context.cs.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
