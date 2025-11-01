import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/google_repository.dart';


class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<User?> call() async {
    return await repository.signInWithGoogle();
  }
}
