import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/data_source/main/wish_list_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/wish_fire_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wish_list_repository.dart';

class WishListRepositoryImple implements WishListRepository {
  final WishListDataSource dataSource;
  final FirebaseAuth auth;

  WishListRepositoryImple({required this.dataSource, required this.auth});

  String get currentUserId => auth.currentUser?.uid ?? '';

  @override
  Future<Either<Failure, Unit>> add(
      String productId, WishListEntities item) async {
    try {
      final wishListId = '${productId}_variant_${item.variantIndex}';
      final addto = WishFireModel(
          id: wishListId,
          name: item.name,
          brand: item.brand,
          variantDetails: item.variantDetails,
          variantIndex: item.variantIndex,
          userId: item.userId,
          addedAt: item.addedAt);
      await dataSource.addToWishList(currentUserId, productId, addto);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'firebase Error'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String productId) async {
    try {
      await dataSource.deleteFrmWishList(currentUserId, productId);
      return right(unit);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorate(String productId) async {
    try {
      final exist = await dataSource.checkInWishList(currentUserId, productId);
      return right(exist);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<WishListEntities>>> watchAll() {
    return dataSource.getWishList(currentUserId).map((models) {
      final entities = models
          .map((m) => WishListEntities(
              id: m.id,
              name: m.name,
              brand: m.brand,
              variantDetails: m.variantDetails,
              variantIndex: m.variantIndex,
              userId: m.userId,
              addedAt: m.addedAt))
          .toList();
      return Right<Failure, List<WishListEntities>>(entities);
    }).handleError((e) =>
        Left<Failure, List<WishListEntities>>(ServerFailure(e.toString())));
  }

  Future<Either<Failure, Unit>> toggle(
      String wishListId, WishListEntities item) async {
    try {
      final exist = await dataSource.checkInWishList(currentUserId, wishListId);
      if (exist) {
        await dataSource.deleteFrmWishList(currentUserId, wishListId);
      } else {
        final addto = WishFireModel(
            id: wishListId,
            name: item.name,
            brand: item.brand,
            variantDetails: item.variantDetails,
            variantIndex: item.variantIndex,
            userId: item.userId,
            addedAt: item.addedAt);
        await dataSource.addToWishList(currentUserId, wishListId, addto);
      }
      return const Right(unit);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'firebase error'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
