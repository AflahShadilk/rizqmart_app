import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/cart/widget/cart_quantity_counter.dart';
class CartItemCard extends StatelessWidget {
final CartEntities cartItem;

  const CartItemCard({super.key, required this.cartItem});
  Future<bool?> _showRemoveDialog(BuildContext context, String cartItemId) {
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
@override
  Widget build(BuildContext context) {
    final variant = cartItem.variantIndex < cartItem.variantDetails.length
        ? cartItem.variantDetails[cartItem.variantIndex]
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
    final discount = cartItem.discount ?? 0;
    final hasDiscount = discount > 0;
    final finalPrice = hasDiscount ? price - (price * discount / 100) : price;
    final cartItemId = '${cartItem.id}_variant_${cartItem.variantIndex}';
    final totalPrice = finalPrice * cartItem.count;

    return Dismissible(
      key: Key(cartItemId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showRemoveDialog(context, cartItemId);
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
                    cartItem.name,
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
                      CartQuantityCounter(
                        cartItemId: cartItemId,
                        count: cartItem.count,
                      ),
Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (cartItem.count > 1)
                            Text(
                              '${cartItem.count} × ₹${finalPrice.toStringAsFixed(2)}',
                              style: context.ts.labelSmall?.copyWith(
                                color: context.cs.secondary.withValues(alpha: 0.6),
                              ),
                            ),
                          if (hasDiscount)
                            Text(
                              '₹${(price * cartItem.count).toStringAsFixed(2)}',
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
}
