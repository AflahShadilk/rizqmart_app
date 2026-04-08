import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/repositories/main/cart_repository.dart';

/// Use case for completely removing a specific product variant from the shopping cart.
class RemoveFromCartUsecase {
  final CartRepository repository;
  const RemoveFromCartUsecase(this.repository);
  Future<Either<Failure, void>> call(String cartItemId){
    return repository.removeCart(cartItemId);
  }
}