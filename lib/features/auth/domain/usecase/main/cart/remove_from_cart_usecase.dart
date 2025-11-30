import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class RemoveFromCartUsecase {
  final CartRepository repository;
  const RemoveFromCartUsecase(this.repository);
  Future<void>call(String cartItemId){
    return repository.removeCart(cartItemId);
  }
}