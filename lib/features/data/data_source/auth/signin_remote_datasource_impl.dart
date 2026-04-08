import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/domain/entities/auth/signin_user_entities.dart';

/// Remote data source implementation for handling standard email/password user sign-in via Firebase.
class SigninRemoteDatasourceImpl {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  SigninRemoteDatasourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  Future<SigninUserEntities> signIn({
    required String email,
    required String password,
  }) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final user = result.user!;

    // Check if the user is blocked
    final userDoc = await firebaseFirestore.collection('users').doc(user.uid).get();
    
    if (userDoc.exists) {
      final userData = userDoc.data();
      if (userData != null && userData['isBlocked'] == true) {
        await firebaseAuth.signOut();
        throw Exception("Your account has been blocked. Please contact support.");
      }
    }

    return SigninUserEntities(
        userId: user.uid, email: user.email ?? '', password: password);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}