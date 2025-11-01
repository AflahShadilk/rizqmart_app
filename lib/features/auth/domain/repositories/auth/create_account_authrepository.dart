import 'package:rizqmart/features/auth/domain/entities/auth/signup_page_entities.dart';

abstract class CreateAccountAuthrepository {
  Future<SignupPageEntities>signUp({required String name,required String email,required String password});
}