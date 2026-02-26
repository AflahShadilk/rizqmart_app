import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

/// A circular icon button widget that adds a specific product variant to the cart.
class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.widget,
    this.variantIndex = 0,
    this.count = 1,
  });

  final ShowProductEntities widget;
  final int variantIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.success500,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Symbols.shopping_cart,
          color: AppColors.white,
          size: 18,
        ),
        onPressed: () {
          _addToCart(context);
        },
      ),
    );
  }

  void _addToCart(BuildContext context) {
    try {
      if (variantIndex >= widget.variantDetails.length) {
        showToast(
          context,
          'Invalid variant selected',
          type: ToastType.error,
        );
        return;
      }
      final cartState=context.read<CartBloc>().state;
      final itemExists= _isItemInCart(cartState);
      if(itemExists){
        final variantName=widget.variantDetails[variantIndex]['variant']??widget.variantDetails[variantIndex]['unitName']??'';
      showToast(context, '${widget.name}${variantName.isNotEmpty ? ' ($variantName)' : ''} already in cart!',
          type: ToastType.warning,);
      return ;
      }
      final cartItem = CartEntities(
        id: widget.id,
        name: widget.name,
        brand: widget.brand,
        description: widget.description,
        variantDetails: widget.variantDetails,
        count: count,
        variantIndex: variantIndex,
        userId: '',
        discount: widget.discount,
      );

      context.read<CartBloc>().add(
            AddToCartEvent(
              productId: widget.id,
              item: cartItem,
            ),
          );

      final variantName = widget.variantDetails[variantIndex]['variant'] ??
          widget.variantDetails[variantIndex]['unitName'] ??
          '';

      showToast(
        context,
        '${widget.name}${variantName.isNotEmpty ? ' ($variantName)' : ''} added to cart!',
        type: ToastType.success,
      );
    } catch (e) {
      showToast(
        context,
        'Failed to add to cart: ${e.toString()}',
        type: ToastType.error,
      );
    }
  }
  bool _isItemInCart(dynamic cartState){
    // ignore: unnecessary_null_comparison
    if(cartState is CartLoadedState && cartState.items!=null){
      return cartState.items.any((item)=>item.id==widget.id&&item.variantIndex==variantIndex);
    }
    return false;
  }
}
