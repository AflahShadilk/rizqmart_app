import 'package:rizqmart/features/auth/data/data_source/main/cart_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/cart_firestore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';

class CartRepositoryImpl implements CartRepository{
  final CartDataSource dataSource;
  CartRepositoryImpl({required this.dataSource});

@override
Stream<List<CartEntities>>getCartItems(){
  final userId=dataSource.currentUserId;  
  return dataSource.getCartItems(userId).map((cart){
    return cart.map((map)=> CartFirestoreModel.fromFireStore(map)).toList();
  });
}

@override
Future<void>addtoCart(String productId,CartEntities item)async{
  final userId=dataSource.currentUserId;
  await dataSource.addToCart(id: productId, name:item.name,brand: item.brand,
      description: item.description ,variantDetails:item. variantDetails, count:item. count, variantIndex:item. variantIndex, userId:userId);
}

@override
Future<void>removeCart(String cartItemId)async{
  final userId=dataSource.currentUserId;
  await dataSource.removeFromCart(userId: userId, cartItemId: cartItemId);
}

@override
Future<void>updateQuantity(String cartItemId,int count)async{
  final userId=dataSource.currentUserId;
  await dataSource.updateQuantity(userId: userId, cartItemId: cartItemId, count: count);
}

@override
Future<void>incrementQuantity(String cartItemId)async{
  final userId=dataSource.currentUserId;
  await dataSource.incrementQuantity(userId: userId, cartItemId: cartItemId);
}

@override
Future<void>decrementQuantity(String cartItemId)async{
  final userId=dataSource.currentUserId;
  await dataSource.decrementQuantity(userId: userId, cartItemId: cartItemId);
}

@override
Future<void> clearCart()async{
  final userId=dataSource.currentUserId;
  await dataSource.clearCart(userId);
}

}