import 'package:rizqmart/features/auth/domain/entities/auth/signin_user_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/signin_authrepository.dart';

class SigninUsecase {
  final SigninAuthrepository signinAuthrepository;
  SigninUsecase( {required this.signinAuthrepository});
  Future<SigninUserEntities>call({required String email,required String password})async{
    return signinAuthrepository.signIn(email: email, password: password);
  }
}