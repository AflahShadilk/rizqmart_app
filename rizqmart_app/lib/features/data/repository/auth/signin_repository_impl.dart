import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/auth/signin_remote_datasource_impl.dart';
import 'package:rizqmart/features/domain/entities/auth/signin_user_entities.dart';
import 'package:rizqmart/features/domain/repositories/auth/signin_authrepository.dart';

/// Repository implementation managing standard email/password sign-in flows and error handling.
class SigninRepositoryImpl implements SigninAuthrepository{
  final SigninRemoteDatasourceImpl signinRemoteDatasourceImpl;
  SigninRepositoryImpl({required this.signinRemoteDatasourceImpl});

  @override
  Future<Either<Failure, SigninUserEntities>> signIn({required String email,required String password}){
    return ErrorHandler.executeApiCall(() => signinRemoteDatasourceImpl.signIn(email: email, password: password));
  }
  
  @override
  Future<Either<Failure, void>> signOut(){
    return ErrorHandler.executeApiCall(() => signinRemoteDatasourceImpl.signOut());
  }
}