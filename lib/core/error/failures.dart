/// Abstract base class representing a generic failure state within the application.
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected server error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Please check your internet connection']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class GoogleSignInCancelled extends AuthFailure {
  const GoogleSignInCancelled() : super('Google Sign-In was cancelled');
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}
