import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/google_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/signin_authrepository.dart';

/// Use case for securely logging out the current user and clearing session data.
class SignoutUsecase {
  final SigninAuthrepository signinAuthrepository;
  final AuthRepository googleRepo;
  SignoutUsecase(this.signinAuthrepository,this.googleRepo);
  Future<Either<Failure, void>> signOutAccount() async {
    final signinResult = await signinAuthrepository.signOut();
    return signinResult.fold(
      (failure) => Left(failure),
      (_) => googleRepo.signOut(),
    );
  }
}