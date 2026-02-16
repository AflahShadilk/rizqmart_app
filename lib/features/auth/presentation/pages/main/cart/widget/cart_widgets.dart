

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/show_order_files.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/reusable_text.dart';


Widget emptyCart(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_cart_outlined,
          size: 100,
          color: context.cs.onSurface.withValues(alpha: .3),
        ),
        16.h,
        ReusableText(
          texts: 'Your cart is empty',
          titleSize: context.ts.titleLarge?.copyWith(
            color: context.cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
        8.h,
        ReusableText(
          texts: 'Add items to get started',
          titleSize: context.ts.bodyMedium?.copyWith(
            color: context.cs.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    ),
  );
}


class ProductContainer extends StatelessWidget {
  const ProductContainer({super.key, required this.cartitems});
  final CartEntities cartitems;

  @override
  Widget build(BuildContext context) {
    final variant = cartitems.variantIndex < cartitems.variantDetails.length
        ? cartitems.variantDetails[cartitems.variantIndex]
        : null;

    
    String imageUrl = '';
    if (variant != null) {
      final imageUrls = variant['imageUrls'];
      if (imageUrls != null && imageUrls is List && imageUrls.isNotEmpty) {
        imageUrl = imageUrls[0].toString();
      }
    }

    final variantName = variant?['unitName'] ?? 'Unknown Variant';
    final price = (variant?['mrp'] ?? 0).toDouble();
    final discount = cartitems.discount ?? 0;
    final hasDiscount = discount > 0;
    final finalPrice = hasDiscount ? price - (price * discount / 100) : price;
    final cartItemId = '${cartitems.id}_variant_${cartitems.variantIndex}';
    final totalPrice = finalPrice * cartitems.count;

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
              color: context.cs.outlineVariant.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ProductImage(
                imageUrl: imageUrl,
                height: 100,
                width: 100,
              ),
            ),
            12.w,
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  Text(
                    cartitems.name,
                    style: context.ts.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.h,

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        variantName,
                        style: context.ts.labelMedium?.copyWith(
                          color: context.cs.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  12.h,

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      quantityCounter(context, cartItemId, cartitems.count),

                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (cartitems.count > 1)
                            Text(
                              '${cartitems.count} × ₹${finalPrice.toStringAsFixed(2)}',
                              style: context.ts.labelSmall?.copyWith(
                                color: context.cs.secondary.withValues(alpha: 0.6),
                              ),
                            ),
                          if (hasDiscount)
                            Text(
                              '₹${(price * cartitems.count).toStringAsFixed(2)}',
                              style: context.ts.labelSmall?.copyWith(
                                color: context.cs.onSurface.withValues(alpha: 0.4),
                                decoration: TextDecoration.lineThrough,
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
          color: context.cs.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          
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

          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: context.cs.onSurface,
              ),
            ),
          ),

          
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
                ?.copyWith(color: context.cs.onSecondary.withValues(alpha: 0.4))),
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
                color: context.cs.onSurface.withValues(alpha: 0.5)),
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
            color: context.cs.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
    ));
  }


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
