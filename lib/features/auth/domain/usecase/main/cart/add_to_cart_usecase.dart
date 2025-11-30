import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class AddToCartUsecase {
  final CartRepository repository;
 const AddToCartUsecase(this.repository);
 Future<void>call(String productId,CartEntities item){
  return repository.addtoCart(productId, item);
 }
}