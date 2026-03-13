import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/core/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/google_auth_remote_data_source.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/google_repository.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User?>> signInWithGoogle() {
    return ErrorHandler.executeApiCall(() => remoteDataSource.signInWithGoogle());
  }

  @override
  Future<Either<Failure, void>> signOut() {
    return ErrorHandler.executeApiCall(() => remoteDataSource.signOut());
  }

  @override
  User? getCurrentUser() => remoteDataSource.getCurrentUser();
}
