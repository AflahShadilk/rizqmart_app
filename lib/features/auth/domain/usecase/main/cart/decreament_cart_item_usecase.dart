import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class DecreamentCartItemUsecase {
  final CartRepository repository;
  const DecreamentCartItemUsecase(this.repository);
  Future<void>call(String cartItemId){
    return repository.decrementQuantity(cartItemId);
  }
}