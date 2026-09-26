import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable{
  @override
  List<Object?> get props => [];
}
class SignUpIniatial extends SignUpState{}
class SignUploading extends SignUpState{}
class SignUpSuccess extends SignUpState{
  final String  message;
  SignUpSuccess(this.message);
  @override
  
  List<Object?> get props => [message];
}
class SignupFailure extends SignUpState {
  final String message;
  SignupFailure(this.message);
  @override
  
  List<Object?> get props => [message];
}
