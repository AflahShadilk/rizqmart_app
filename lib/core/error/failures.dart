abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {

  const AuthFailure(super.message);
}

class GoogleSignInCancelled extends AuthFailure {
  GoogleSignInCancelled() : super('Google Sign-In was cancelled');
}
