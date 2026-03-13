import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';
class DecreamentCartItemUsecase {
  final CartRepository repository;
  const DecreamentCartItemUsecase(this.repository);
  Future<Either<Failure, void>> call(String cartItemId){
    return repository.decrementQuantity(cartItemId);
  }
}