import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
class ProductCartCheckCubit extends Cubit<bool> {
  ProductCartCheckCubit() : super(false);

  bool isItemInCart(CartState cartState, String productId, int variantIndex) {
    if (cartState is CartLoadedState) {
      return cartState.items.any(
        (item) => item.id == productId && item.variantIndex == variantIndex,
      );
    }
    return false;
  }

  String getWishlistId(String productId, int variantIdx) {
    return '${productId}_variant_$variantIdx';
  }
}
