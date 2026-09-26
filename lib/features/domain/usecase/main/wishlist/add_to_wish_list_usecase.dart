import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/wish_list_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/wish_list_repository.dart';

/// Use case for saving a specific product into a user's personal favorites or wishlist.
class AddToWishListUsecase {
  final WishListRepository wishListRepository;
 const AddToWishListUsecase(this.wishListRepository);
  Future<Either<Failure,Unit>>call(String productId,WishListEntities item){
    return wishListRepository.add(productId, item);
  }
}