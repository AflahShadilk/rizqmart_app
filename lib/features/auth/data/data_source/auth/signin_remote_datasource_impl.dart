import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/domain/entities/auth/signin_user_entities.dart';

/// Remote data source implementation for handling standard email/password user sign-in via Firebase.
class SigninRemoteDatasourceImpl {
  final FirebaseAuth firebaseAuth;
  SigninRemoteDatasourceImpl({required this.firebaseAuth});
  
  Future<SigninUserEntities>signIn({required String email,required String password})async{
   final result=await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
   final user=result.user!;
   return SigninUserEntities(userId: user.uid, email: user.email??'', password: password);
   
  }
  
  Future<void>signOut()async{
    await firebaseAuth.signOut();
   
  }

}