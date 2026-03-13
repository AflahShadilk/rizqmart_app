import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
abstract class ForgotpassAuthrepo {
  Future<Either<Failure, void>> sendEmail(String email);
}