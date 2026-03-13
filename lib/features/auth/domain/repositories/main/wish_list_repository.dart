
import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
abstract class WishListRepository {
  Future<Either<Failure,Unit>>add(String productId,WishListEntities item);
  Future<Either<Failure, Unit>> delete(String productId);
  Future<Either<Failure,bool>>isFavorate(String productId);
  Stream<Either<Failure,List<WishListEntities>>>watchAll();
}