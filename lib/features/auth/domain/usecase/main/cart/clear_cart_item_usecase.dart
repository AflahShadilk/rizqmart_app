import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class ClearCartItemUsecase {
  final CartRepository repository;
  const ClearCartItemUsecase(this.repository);
Future<void>call(){
  return repository.clearCart();
}

}