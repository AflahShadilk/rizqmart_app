
import 'package:equatable/equatable.dart';

abstract class GooogleAuthEvent extends Equatable {
  const GooogleAuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithGoogleEvent extends GooogleAuthEvent {}