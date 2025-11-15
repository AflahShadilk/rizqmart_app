import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/data_source/main/wish_list_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/wish_fire_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wish_list_repository.dart';

class WishListRepositoryImple implements WishListRepository{
  final WishListDataSource dataSource;
  String userId;
  WishListRepositoryImple({required this.dataSource,required this.userId});

  @override
  Future<Either<Failure,Unit>>add(String productId,WishListEntities item)async{
    try{
      final addto=WishFireModel(id: item.id, name: item.name, variantDetails: item.variantDetails,addedAt: item.addedAt);
     await dataSource.addToWishList(userId, productId, addto);
     return const Right(unit);

    }on FirebaseException catch(e){
      return left(ServerFailure( e.message??'firebase Error'));
    }catch (e){
     return left(ServerFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure,Unit>>delete(String productId)async{
    try{
      await dataSource.deleteFrmWishList(userId, productId);
      return right(unit);
    }on FirebaseException catch(e){
       return left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure,bool>>isFavorate(String productId)async{
    try{
      final exist=await dataSource.checkInWishList(userId, productId);
      return right(exist);
    }on FirebaseException catch (e){
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<WishListEntities>>>watchAll(){
   return dataSource.getWishList(userId).map((models){
    final entities=models.map((m)=>WishListEntities(id: m.id, name:m. name, variantDetails:m. variantDetails,addedAt: m.addedAt)).toList();
    return Right<Failure,List<WishListEntities>>(entities);
   }).handleError((e)=>Left<Failure,List<WishListEntities>>(ServerFailure(e.toString())));
  }

}