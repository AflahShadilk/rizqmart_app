import 'package:rizqmart/features/auth/data/data_source/auth/signup_remote_datasource.dart';
import 'package:rizqmart/features/auth/domain/entities/auth/signup_page_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/create_account_authrepository.dart';

class SignupRepositoryImpl implements CreateAccountAuthrepository{
  final SignupRemoteDatasource signupRemoteDatasource;
  SignupRepositoryImpl(this.signupRemoteDatasource);
  @override
  Future <SignupPageEntities>signUp({
    required String name,
    required String email,
    required String password,
  })async{
    final data=await signupRemoteDatasource.signUp(name: name, email: email, password: password);
    return SignupPageEntities(
      userId: data['uid'],
      name: data['name'],
      email: data['email']
    );
  }
}