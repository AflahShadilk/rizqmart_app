import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

/// Use case for streaming the current items and quantities in the user's shopping cart.
class GetCartItemsUsecase {
  final CartRepository repository;
 const GetCartItemsUsecase(this.repository);
  Stream<Either<Failure, List<CartEntities>>> call(){
    return repository.getCartItems(); 
  }
}