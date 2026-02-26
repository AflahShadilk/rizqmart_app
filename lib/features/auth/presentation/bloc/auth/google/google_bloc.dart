import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/constants.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/google_sign_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/google/google.state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/google/google_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Business logic for handling user sign-in via Google.
class GooogleAuthBloc extends Bloc<GooogleAuthEvent, GooogleAuthState> {
  final SignInWithGoogle signInWithGoogle;

  GooogleAuthBloc({required this.signInWithGoogle}) : super(GooogleAuthInitial()) {
    on<SignInWithGoogleEvent>((event, emit) async {
      emit(GooogleAuthLoading());
      final result = await signInWithGoogle();
      
      await result.fold(
        (failure) async => emit(GooogleAuthFailure(failure.message)),
        (user) async {
          if (user != null) {
            final pref = await SharedPreferences.getInstance();
            await pref.setBool(saveKey, true);
            emit(GooogleAuthSuccess(user));
          } else {
            emit(const GooogleAuthFailure("Sign-in cancelled"));
          }
        },
      );
    });
  }
}