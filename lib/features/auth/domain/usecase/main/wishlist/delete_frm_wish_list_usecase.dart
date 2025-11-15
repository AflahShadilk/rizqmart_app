
import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wish_list_repository.dart';

class DeleteFrmWishListUsecase {
  final WishListRepository repository;
 const DeleteFrmWishListUsecase(this.repository);
 Future<Either<Failure,Unit>>call(String productId){
  return repository.delete(productId);
 }
}