import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/auth/signin_user_entities.dart';
import 'package:rizqmart/features/domain/repositories/auth/signin_authrepository.dart';

/// Use case for authenticating a user with their email and password credentials.
class SigninUsecase {
  final SigninAuthrepository signinAuthrepository;
  SigninUsecase( {required this.signinAuthrepository});
  Future<Either<Failure, SigninUserEntities>> call({required String email,required String password})async{
    return signinAuthrepository.signIn(email: email, password: password);
  }
}