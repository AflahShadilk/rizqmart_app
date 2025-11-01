import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable{
  @override
  
  List<Object?> get props => [];
}
class SignInInitializeState extends SignInState{}
class SignInLoadingState extends SignInState{}
class SignInSuccessState extends SignInState{
  final String massage;
  SignInSuccessState(this.massage);
}
class SignInFailureState extends SignInState{
  final String error;
  SignInFailureState(this.error);
}
