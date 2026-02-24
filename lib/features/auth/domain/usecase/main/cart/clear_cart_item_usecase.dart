import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class ClearCartItemUsecase {
  final CartRepository repository;
  const ClearCartItemUsecase(this.repository);
  Future<Either<Failure, void>> call(){
    return repository.clearCart();
  }
}