import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wish_list_repository.dart';

class GetAllWishListUsecase {
  final WishListRepository wishListRepository;
  const GetAllWishListUsecase(this.wishListRepository);
  Stream<Either<Failure,List<WishListEntities>>>call(){
    return wishListRepository.watchAll();
  }
}