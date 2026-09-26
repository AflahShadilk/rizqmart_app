import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/repositories/main/cart_repository.dart';

/// Use case for setting a specific numerical quantity for an item in the shopping cart.
class UpdateCartitemQuantityUsecase {
  final CartRepository repository;
  const UpdateCartitemQuantityUsecase(this.repository);
  Future<Either<Failure, void>> call(String cartItemId,int count){
    return repository.updateQuantity(cartItemId, count);
  }
}