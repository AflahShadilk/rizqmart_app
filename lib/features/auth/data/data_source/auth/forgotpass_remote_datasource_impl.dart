import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/core/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/forgotpass_authrepo.dart';

/// Remote data source implementation for handling forgot password requests via Firebase Auth.
class ForgotpassRemoteDatasourceImpl implements ForgotpassAuthrepo{
  final FirebaseAuth firebaseAuth;
  ForgotpassRemoteDatasourceImpl({required this.firebaseAuth});
  @override
  Future<Either<Failure, void>> sendEmail(String email) {
    return ErrorHandler.executeApiCall(() async {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    });
  }
}
