import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/auth/signin_user_entities.dart';

abstract class SignInState extends Equatable{
  @override
  
  List<Object?> get props => [];
}
class SignInInitializeState extends SignInState{}
class SignInLoadingState extends SignInState{}
class SignInSuccessState extends SignInState{
  final String massage;
  final SigninUserEntities   user;
  SignInSuccessState(this.massage,{required this.user});
  @override
  List<Object?> get props => [massage,user];
}

class SignInFailureState extends SignInState{
  final String error;
  SignInFailureState(this.error);
}
