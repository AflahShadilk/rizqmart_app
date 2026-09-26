import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  
  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;
  final String conformPass;
   SignupSubmitted(
      {required this.name, required this.email, required this.password,required this.conformPass});
  @override
  List<Object?> get props => [name, email, password,conformPass];
}