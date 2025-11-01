
import 'package:equatable/equatable.dart';

class SigninUserEntities extends Equatable {
  final String userId;
 final String email;
 final String password;
 const SigninUserEntities({required this.userId, required this.email,required this.password});
 @override
  
  List<Object?> get props => [userId,email,password];
}