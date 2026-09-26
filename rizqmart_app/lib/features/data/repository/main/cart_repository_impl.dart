import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/main/cart_data_source.dart';
import 'package:rizqmart/features/data/model/main/cart_firestore_model.dart';
import 'package:rizqmart/features/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/cart_repository.dart';

/// Repository implementation connecting cart features to data sources seamlessly.
class CartRepositoryImpl implements CartRepository{
  final CartDataSource dataSource;
  CartRepositoryImpl({required this.dataSource});

  @override
  Stream<Either<Failure, List<CartEntities>>> getCartItems(){
    final userId=dataSource.currentUserId;  
    return ErrorHandler.executeApiStream(() => dataSource.getCartItems(userId).map((cart){
      return cart.map((map)=> CartFirestoreModel.fromFireStore(map)).toList();
    }));
  }

  @override
  Future<Either<Failure, void>> addtoCart(String productId,CartEntities item) {
    return ErrorHandler.executeApiCall(() async {
      final userId=dataSource.currentUserId;
      await dataSource.addToCart(id: productId, name:item.name,brand: item.brand,
          description: item.description ,variantDetails:item. variantDetails, count:item. count, variantIndex:item. variantIndex, userId:userId, discount: item.discount);
    });
  }

  @override
  Future<Either<Failure, void>> removeCart(String cartItemId) {
    return ErrorHandler.executeApiCall(() async {
      final userId=dataSource.currentUserId;
      await dataSource.removeFromCart(userId: userId, cartItemId: cartItemId);
    });
  }

  @override
  Future<Either<Failure, void>> updateQuantity(String cartItemId,int count) {
    return ErrorHandler.executeApiCall(() async {
      final userId=dataSource.currentUserId;
      await dataSource.updateQuantity(userId: userId, cartItemId: cartItemId, count: count);
    });
  }

  @override
  Future<Either<Failure, void>> incrementQuantity(String cartItemId) {
    return ErrorHandler.executeApiCall(() async {
      final userId=dataSource.currentUserId;
      await dataSource.incrementQuantity(userId: userId, cartItemId: cartItemId);
    });
  }

  @override
  Future<Either<Failure, void>> decrementQuantity(String cartItemId) {
    return ErrorHandler.executeApiCall(() async {
      final userId=dataSource.currentUserId;
      await dataSource.decrementQuantity(userId: userId, cartItemId: cartItemId);
    });
  }

  @override
  Future<Either<Failure, void>> clearCart() {
    return ErrorHandler.executeApiCall(() async {
      final userId=dataSource.currentUserId;
      await dataSource.clearCart(userId);
    });
  }
}