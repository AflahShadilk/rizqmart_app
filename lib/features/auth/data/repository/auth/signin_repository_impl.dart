import 'package:rizqmart/features/auth/data/data_source/auth/signin_remote_datasource_impl.dart';
import 'package:rizqmart/features/auth/domain/entities/auth/signin_user_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/signin_authrepository.dart';

class SigninRepositoryImpl implements SigninAuthrepository{
  final SigninRemoteDatasourceImpl signinRemoteDatasourceImpl;
  SigninRepositoryImpl({required this.signinRemoteDatasourceImpl});

  @override
  Future<SigninUserEntities>signIn({required String email,required String password}){
    return signinRemoteDatasourceImpl.signIn(email: email, password: password);
  }
}