import 'package:rizqmart/features/auth/domain/repositories/auth/forgotpass_authrepo.dart';

class ForgotpassUsecase {
  final ForgotpassAuthrepo forgotpassAuthrepo;
  ForgotpassUsecase( this.forgotpassAuthrepo);
  Future<void>call(String email){
    return forgotpassAuthrepo.sendEmail(email);
  }
}