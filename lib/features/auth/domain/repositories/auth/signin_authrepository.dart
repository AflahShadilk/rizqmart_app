import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/auth/signin_user_entities.dart';

abstract class SigninAuthrepository {
  Future<Either<Failure, SigninUserEntities>> signIn({required String email,required String password});
  Future<Either<Failure, void>> signOut();
}