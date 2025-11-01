class Failures {
  final String message;
  Failures({required this.message});
}
class ServerFailure extends Failures{
  ServerFailure({required String message}):super(message: message);
}


abstract class Failure {
  final String message;
  Failure(this.message);
}

class AuthFailure extends Failure {
  // ignore: use_super_parameters
  AuthFailure(String message) : super(message);
}

class GoogleSignInCancelled extends AuthFailure {
  GoogleSignInCancelled() : super('Google Sign-In was cancelled');
}
