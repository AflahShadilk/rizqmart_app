import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/signup_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signUp/signup_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signUp/signup_state.dart';

class SignupBloc extends Bloc<SignUpEvent,SignUpState>{
  final SignupUsecase signupUsecase;
  SignupBloc(this.signupUsecase):super(SignUpIniatial()){
    on<SignupSubmitted>(signUpfunction);
  }
  Future<void>signUpfunction(SignupSubmitted event,Emitter<SignUpState>emit)async{
    emit(SignUploading());
    try{
      if(event.password!=event.conformPass){
        emit(SignupFailure('Password do not matching'));
        return;
      }
      await signupUsecase(name: event.name,email: event.email,password: event.password);
      emit(SignUpSuccess('Account created Successfully'));
    }on FirebaseAuthException catch(e){
      emit(SignupFailure(e.message??'Something went wrong'));
    }
  }
}