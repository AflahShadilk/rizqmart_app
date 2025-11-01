import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/google_auth_remote_data_source.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/google_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User?> signInWithGoogle() => remoteDataSource.signInWithGoogle();

  @override
  Future<void> signOut() => remoteDataSource.signOut();

  @override
  User? getCurrentUser() => remoteDataSource.getCurrentUser();
}
