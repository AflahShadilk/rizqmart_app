import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';

abstract class CartRepository {
  Stream<List<CartEntities>> getCartItems();
  Future<void> addtoCart(String productId, CartEntities item);
  Future<void> removeCart(String cartItemId);
  Future<void> updateQuantity(String cartItemId, int count);
  Future<void> incrementQuantity(String cartItemId);
  Future<void> decrementQuantity(String cartItemId);
  Future<void> clearCart();
}