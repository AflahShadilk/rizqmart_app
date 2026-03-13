import 'package:equatable/equatable.dart';
class SigninUserEntities extends Equatable {
  final String userId;
  final String email;
  final String password;
  final String? displayName;
  final String? photoURL;

  const SigninUserEntities({
    required this.userId,
    required this.email,
    required this.password,
    this.displayName,
    this.photoURL,
  });

  @override
  List<Object?> get props => [userId, email, password, displayName, photoURL];
}