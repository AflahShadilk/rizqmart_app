import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class GetCartItemsUsecase {
  final CartRepository repository;
 const GetCartItemsUsecase(this.repository);
  Stream<List<CartEntities>>call(){
    return repository.getCartItems(); 
  }
}