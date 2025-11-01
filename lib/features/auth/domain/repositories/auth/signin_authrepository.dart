
import 'package:rizqmart/features/auth/domain/entities/auth/signin_user_entities.dart';

abstract class SigninAuthrepository {
  Future<SigninUserEntities>signIn({required String email,required String password});
}