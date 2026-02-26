import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/signup_remote_datasource.dart';
import 'package:rizqmart/features/auth/domain/entities/auth/signup_page_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/create_account_authrepository.dart';

/// Repository implementation handling user registration, encapsulating data sources and failure states.
class SignupRepositoryImpl implements CreateAccountAuthrepository{
  final SignupRemoteDatasource signupRemoteDatasource;
  SignupRepositoryImpl(this.signupRemoteDatasource);
  
  @override
  Future<Either<Failure, SignupPageEntities>> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return ErrorHandler.executeApiCall(() async {
      final data=await signupRemoteDatasource.signUp(name: name, email: email, password: password);
      return SignupPageEntities(
        userId: data['uid'],
        name: data['name'],
        email: data['email']
      );
    });
  }
}