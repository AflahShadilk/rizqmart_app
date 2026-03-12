import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Interface for defining remote authentication operations like Google Sign-In and sign out.
abstract class AuthRemoteDataSource {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
}

/// Firebase-backed implementation of the `AuthRemoteDataSource` for Google authentication.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firebaseFirestore,
  });

  @override
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final userDoc = await firebaseFirestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData['isBlocked'] == true) {
          await signOut();
          throw Exception("Your account has been blocked. Please contact support.");
        }
      } else {
        // Create user document for new Google sign-in
        await firebaseFirestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? 'Google User',
          'email': user.email ?? '',
          'createdAt': DateTime.now().toIso8601String(),
          'walletBalance': 0.0,
          'isBlocked': false,
        });
      }
    }

    return user;
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  @override
  User? getCurrentUser() => firebaseAuth.currentUser;
}
