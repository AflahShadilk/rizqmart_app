import 'package:rizqmart/features/auth/domain/repositories/auth/google_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/signin_authrepository.dart';

class SignoutUsecase {
  final SigninAuthrepository signinAuthrepository;
  final AuthRepository googleRepo;
  SignoutUsecase(this.signinAuthrepository,this.googleRepo);
  Future<void>signOutAccount()async{
    await signinAuthrepository.signOut();
    await googleRepo.signOut();
  }
}