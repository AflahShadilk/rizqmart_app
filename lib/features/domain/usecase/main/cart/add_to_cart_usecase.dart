import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/cart_repository.dart';

/// Use case for adding a specific product variant to the user's shopping cart.
class AddToCartUsecase {
  final CartRepository repository;
 const AddToCartUsecase(this.repository);
 Future<Either<Failure, void>> call(String productId,CartEntities item){
  return repository.addtoCart(productId, item);
 }
}