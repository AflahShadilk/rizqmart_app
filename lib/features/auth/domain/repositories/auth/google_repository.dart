import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/core/error/failures.dart';
abstract class AuthRepository {
  Future<Either<Failure, User?>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  User? getCurrentUser();
}
