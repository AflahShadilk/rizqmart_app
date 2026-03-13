class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'An unexpected server error occurred']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Please check your internet connection']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication failed']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error occurred']);
}

class UnknownException implements Exception {
  final String message;
  const UnknownException([this.message = 'An unknown error occurred']);
}
