import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/cart_entities.dart';

/// Abstract repository defining operations for the user's shopping cart.
abstract class CartRepository {
  Stream<Either<Failure, List<CartEntities>>> getCartItems();
  Future<Either<Failure, void>> addtoCart(String productId, CartEntities item);
  Future<Either<Failure, void>> removeCart(String cartItemId);
  Future<Either<Failure, void>> updateQuantity(String cartItemId, int count);
  Future<Either<Failure, void>> incrementQuantity(String cartItemId);
  Future<Either<Failure, void>> decrementQuantity(String cartItemId);
  Future<Either<Failure, void>> clearCart();
}