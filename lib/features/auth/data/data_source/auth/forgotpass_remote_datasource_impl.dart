import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/forgotpass_authrepo.dart';


class ForgotpassRemoteDatasourceImpl implements ForgotpassAuthrepo{
  final FirebaseAuth firebaseAuth;
  ForgotpassRemoteDatasourceImpl({required this.firebaseAuth});
  @override
  Future<void>sendEmail(String email)async{
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
