import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable{
  @override
  
  List<Object?> get props => [];
}
class SignInSubmittedEvent extends SignInEvent{
  final String emailId;
  final String password;
  SignInSubmittedEvent({required this.emailId,required this.password});
  @override

  List<Object?> get props => [emailId,password];
}