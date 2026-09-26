import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/auth/google_auth_remote_data_source.dart';
import 'package:rizqmart/features/domain/repositories/auth/google_repository.dart';

/// Repository implementation coordinating Google authentication processes and user mapping.
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
