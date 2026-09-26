import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/repositories/main/cart_repository.dart';

/// Use case for completely emptying the user's shopping cart.
class ClearCartItemUsecase {
  final CartRepository repository;
  const ClearCartItemUsecase(this.repository);
  Future<Either<Failure, void>> call(){
    return repository.clearCart();
  }
}