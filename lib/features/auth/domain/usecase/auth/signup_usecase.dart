import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/auth/signup_page_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/create_account_authrepository.dart';

/// Use case for registering a new user account with their provided details.
class SignupUsecase {
  final CreateAccountAuthrepository createAccountAuthrepository;
  SignupUsecase(this.createAccountAuthrepository);

  Future<Either<Failure, SignupPageEntities>> call({required String name,required String email,required String password}){
   return createAccountAuthrepository.signUp(name:name, email:email, password:password);
  }
}