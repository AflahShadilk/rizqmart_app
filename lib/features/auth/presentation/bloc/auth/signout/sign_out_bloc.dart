import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/constants.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/signout_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Business logic for securely signing the user out of the application.
class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignoutUsecase signoutUsecase;

  SignOutBloc({required this.signoutUsecase}) : super(InitializeSignOutState()) {
    on<SignOutRequestedEvent>(_onSignOutRequested);
  }

  Future<void> _onSignOutRequested(
    SignOutRequestedEvent event,
    Emitter<SignOutState> emit,
  ) async {
    emit(LoadingSignOutState());
    
    final result = await signoutUsecase.signOutAccount();
    
    await result.fold(
      (failure) async => emit(SignOutFailureState(failure.message)),
      (_) async {
        emit(SignOutSuccessState('Sign out successful'));
        final pref = await SharedPreferences.getInstance();
        await pref.setBool(saveKey,false);
      },
    );
  }
}