import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/repositories/auth/forgotpass_authrepo.dart';

/// Use case for initiating the password recovery process via email.
class ForgotpassUsecase {
  final ForgotpassAuthrepo forgotpassAuthrepo;
  ForgotpassUsecase( this.forgotpassAuthrepo);
  Future<Either<Failure, void>> call(String email){
    return forgotpassAuthrepo.sendEmail(email);
  }
}