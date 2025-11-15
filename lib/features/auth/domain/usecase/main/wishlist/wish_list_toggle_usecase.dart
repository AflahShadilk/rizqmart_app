
import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wish_list_repository.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/add_to_wish_list_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/delete_frm_wish_list_usecase.dart';

class WishListToggleUsecase {
  final AddToWishListUsecase addToWishListUsecase;
  final DeleteFrmWishListUsecase deleteFrmWishListUsecase;
  final WishListRepository wishListRepository;
  const WishListToggleUsecase(this.addToWishListUsecase,this.deleteFrmWishListUsecase,this.wishListRepository);
  Future<Either<Failure,Unit>>call(String productId,WishListEntities item)async{
    final isFav=await wishListRepository.isFavorate(productId);
    return isFav.fold((failure)=>left(failure), ( fav)=>fav? deleteFrmWishListUsecase(productId):addToWishListUsecase(productId,item));
  }
}