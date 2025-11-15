import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/constants.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/signout_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    try {
      await signoutUsecase.signOutAccount();
      emit(SignOutSuccessState('Sign out successful'));
         final pref = await SharedPreferences.getInstance();
    await pref.setBool(saveKey,false);
    } on FirebaseAuthException catch (e) {
      emit(SignOutFailureState(_getErrorMessage(e)));
    } catch (e) {
      emit(SignOutFailureState('An unexpected error occurred'));
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'Sign out failed';
    }
  }
}