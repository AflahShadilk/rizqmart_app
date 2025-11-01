import 'package:rizqmart/features/auth/domain/entities/auth/signup_page_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/create_account_authrepository.dart';

class SignupUsecase {
  final CreateAccountAuthrepository createAccountAuthrepository;
  SignupUsecase(this.createAccountAuthrepository);

  Future<SignupPageEntities>call({required String name,required String email,required String password}){
   return createAccountAuthrepository.signUp(name:name, email:email, password:password);
  }
}