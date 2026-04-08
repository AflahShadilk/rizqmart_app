import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/domain/usecase/auth/signup_usecase.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signUp/signup_event.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signUp/signup_state.dart';

/// Business logic for handling new user registration and validation.
class SignupBloc extends Bloc<SignUpEvent,SignUpState>{
  final SignupUsecase signupUsecase;
  SignupBloc(this.signupUsecase):super(SignUpIniatial()){
    on<SignupSubmitted>(signUpfunction);
  }
  Future<void>signUpfunction(SignupSubmitted event,Emitter<SignUpState>emit)async{
    emit(SignUploading());
    
    if(event.password!=event.conformPass){
      emit(SignupFailure('Password do not matching'));
      return;
    }
    
    final result = await signupUsecase(name: event.name,email: event.email,password: event.password);
    result.fold(
      (failure) => emit(SignupFailure(failure.message)),
      (_) => emit(SignUpSuccess('Account created Successfully')),
    );
  }
}