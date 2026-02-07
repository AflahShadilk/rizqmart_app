import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/constants.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/signin_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signIn/signin_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signIn/signin_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninBloc extends Bloc<SignInEvent,SignInState>{
 final SigninUsecase signinUsecase;
 SigninBloc({required this.signinUsecase}):super(SignInInitializeState()){
  on<SignInSubmittedEvent>(checkingStatus);
 }
 Future<void>checkingStatus(SignInSubmittedEvent event,Emitter<SignInState>emit)async{
  emit(SignInLoadingState());
  try{
      final result=await signinUsecase(email: event.emailId,password: event.password);
      emit(SignInSuccessState('Logged Into ${result.email}',user: result));
        final pref = await SharedPreferences.getInstance();
    await pref.setBool(saveKey, true);
    
  }on FirebaseAuthException catch (e){
    emit(SignInFailureState(e.message??'Login Failed'));

  }catch (e){
    emit(SignInFailureState('Something went wrong: ${e.toString()}'));
  }
 }
}