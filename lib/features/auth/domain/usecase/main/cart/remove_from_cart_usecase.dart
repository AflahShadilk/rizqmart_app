import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class RemoveFromCartUsecase {
  final CartRepository repository;
  const RemoveFromCartUsecase(this.repository);
  Future<Either<Failure, void>> call(String cartItemId){
    return repository.removeCart(cartItemId);
  }
}