import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class UpdateCartitemQuantityUsecase {
  final CartRepository repository;
  const UpdateCartitemQuantityUsecase(this.repository);
  Future<void>call(String cartItemId,int count){
    return repository.updateQuantity(cartItemId, count);
  }
}