import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class IncrementCartItemUsecase {
  final CartRepository repository;
  const IncrementCartItemUsecase(this.repository);

  Future<void>call(String cartItemId){
    return repository.incrementQuantity(cartItemId);
  }
}