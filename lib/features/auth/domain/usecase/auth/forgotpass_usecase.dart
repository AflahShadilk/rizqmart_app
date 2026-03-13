import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/forgotpass_authrepo.dart';
class ForgotpassUsecase {
  final ForgotpassAuthrepo forgotpassAuthrepo;
  ForgotpassUsecase( this.forgotpassAuthrepo);
  Future<Either<Failure, void>> call(String email){
    return forgotpassAuthrepo.sendEmail(email);
  }
}