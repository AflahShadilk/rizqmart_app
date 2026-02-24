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
    final result = await forgotpassUsecase(event.emailId);
    result.fold(
      (failure) => emit(ForgotFailure(failure.message)),
      (_) => emit(ForgotSuccess('Email sending Successful')),
    );
  }
}