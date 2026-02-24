import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/auth/signin_user_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/signin_authrepository.dart';

class SigninUsecase {
  final SigninAuthrepository signinAuthrepository;
  SigninUsecase( {required this.signinAuthrepository});
  Future<Either<Failure, SigninUserEntities>> call({required String email,required String password})async{
    return signinAuthrepository.signIn(email: email, password: password);
  }
}