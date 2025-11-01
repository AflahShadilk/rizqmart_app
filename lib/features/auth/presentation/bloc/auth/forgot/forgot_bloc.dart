import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/forgotpass_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/forgot/forgot_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/forgot/forgot_state.dart';


class ForgotBloc extends Bloc<ForgotEvent,ForgotState>{
  final ForgotpassUsecase forgotpassUsecase;
  ForgotBloc({required this.forgotpassUsecase}):super(ForgotInitial()){
    on<ForgotSubmitted>(sendingEmail);
  }
  Future <void>sendingEmail(ForgotSubmitted event,Emitter<ForgotState>emit)async{
    emit(ForgotLoading());
    try{
      await forgotpassUsecase(event.emailId);
      emit(ForgotSuccess('Email sending Successful'));
    }on FirebaseAuthException catch (e){
      emit(ForgotFailure(e.toString()));
    }
  }
}