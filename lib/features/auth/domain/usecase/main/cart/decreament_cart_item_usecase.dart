import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

/// Use case for reducing the quantity of a specific item in the shopping cart by one.
class DecreamentCartItemUsecase {
  final CartRepository repository;
  const DecreamentCartItemUsecase(this.repository);
  Future<Either<Failure, void>> call(String cartItemId){
    return repository.decrementQuantity(cartItemId);
  }
}