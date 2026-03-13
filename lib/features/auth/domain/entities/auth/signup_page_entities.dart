import 'package:equatable/equatable.dart';
class SignupPageEntities extends Equatable{
 final String userId;
 final String name;
 final String email;
 const SignupPageEntities({required this.userId,required this.name,required this.email});

 @override
  
  List<Object?> get props => [userId,name,email];
}