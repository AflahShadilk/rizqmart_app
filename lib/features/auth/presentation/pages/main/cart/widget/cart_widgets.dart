// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/core/theme/theme_cubit.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/reusable_main_button.dart';

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
        const SizedBox(
          height: 16,
        ),
        Text(
          'Your cart is empty',
          style: context.ts.titleLarge?.copyWith(
            color: context.cs.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Add items to get started',
          style: context.ts.bodyMedium?.copyWith(
            color: context.cs.onSurface.withOpacity(0.4),
          ),
        ),
      ],
    ),
  );
}

//ca
Widget cardSummery(BuildContext context, CartLoadedState state) {
  final size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width * 0.9,
    height: 50,
    child: MainButton(
        label: 'Go to Checkout   ₹${state.totalAmount.toStringAsFixed(2)}',
        onPress: () {
          //show button sheet 
        },
        color: context.cs.success,
        textColor: ThemeCubit.textSecondaryDark),
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
    //set image
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
        decoration: BoxDecoration(
          color: AppColors.error500,
        ),
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.white,
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
              child: imageUrl.isNotEmpty
                  ? ProductImage(
                      imageUrl: imageUrl,
                      height: 100,
                      width: 100,
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      color: context.cs.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: context.cs.onSurface.withOpacity(0.3),
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            // Product Details
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
                  const SizedBox(height: 4),

                  // Variant Name
                  Text(
                    variantName,
                    style: context.ts.labelMedium?.copyWith(
                      color: context.cs.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      quantityCounter(context, cartItemId, cartitems.count),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget quantityCounter(BuildContext context, String cartItemId, int count) {
    return Container(
      decoration: BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement
          InkWell(
            onTap: () {
              if (count > 1) {
                context
                    .read<CartBloc>()
                    .add(DecrementQuantityEvent(cartItemId));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.remove,
                color: context.cs.primary.withOpacity(0.7),
                size: 18,
              ),
            ),
          ),

          // Count Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.cs.primary.withOpacity(0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
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
        title: const Text('Remove Item'),
        content: const Text(
            'Are you sure you want to remove this item from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CartBloc>().add(RemoveFromCartEvent(cartItemId));
              Navigator.pop(dialogContext, true);
            },
            child: Text(
              'Remove',
              style: TextStyle(color: AppColors.error500),
            ),
          ),
        ],
      ),
    );
  }
}
