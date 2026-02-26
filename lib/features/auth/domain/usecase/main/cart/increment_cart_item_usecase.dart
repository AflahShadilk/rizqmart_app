import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

/// Use case for increasing the quantity of a specific item in the shopping cart by one.
class IncrementCartItemUsecase {
  final CartRepository repository;
  const IncrementCartItemUsecase(this.repository);

  Future<Either<Failure, void>> call(String cartItemId){
    return repository.incrementQuantity(cartItemId);
  }
}