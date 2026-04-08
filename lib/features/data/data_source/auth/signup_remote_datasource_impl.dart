import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/data/data_source/auth/signup_remote_datasource.dart';


/// Firebase-backed implementation of `SignupRemoteDatasource` for registering new users and storing their initial profile data.
class SignupRemoteDatasourceImpl implements SignupRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  SignupRemoteDatasourceImpl(
      {required this.firebaseAuth, required this.firebaseFirestore});
  @override
  Future<Map<String, dynamic>> signUp(
      {required String name,
      required String email,
      required String password}) async {
    final credantial = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final userId = credantial.user!.uid;
    await firebaseFirestore.collection('users').doc(userId).set({
      'uid': userId,
      'name': name,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
      'walletBalance': 0.0,
      'isBlocked': false,
    });
    
    return {
      'uid': userId,
      'name': name,
      'email': email,
    };
  }
}
