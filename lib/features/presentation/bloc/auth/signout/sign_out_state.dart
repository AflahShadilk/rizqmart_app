import 'package:equatable/equatable.dart';

abstract class SignOutState extends Equatable{
  @override
  
  List<Object?> get props => [];
}

class InitializeSignOutState extends SignOutState{}
class LoadingSignOutState extends SignOutState{}

class SignOutSuccessState extends SignOutState{
  final String message;
  SignOutSuccessState (this.message);
  @override
  List<Object?> get props => [message];
}


class SignOutFailureState extends SignOutState{
  final String error;
  SignOutFailureState(this.error);
  @override
  
  List<Object?> get props => [error];
}