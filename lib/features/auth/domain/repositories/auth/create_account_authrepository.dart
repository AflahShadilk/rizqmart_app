import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/auth/signup_page_entities.dart';
abstract class CreateAccountAuthrepository {
  Future<Either<Failure, SignupPageEntities>> signUp({required String name,required String email,required String password});
}