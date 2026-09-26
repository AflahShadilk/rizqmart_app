import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class GooogleAuthState extends Equatable {
  const GooogleAuthState();

  @override
  List<Object?> get props => [];
}

class GooogleAuthInitial extends GooogleAuthState {}

class GooogleAuthLoading extends GooogleAuthState {}

class GooogleAuthSuccess extends GooogleAuthState {
  final User user;
  const GooogleAuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class GooogleAuthFailure extends GooogleAuthState {
  final String message;
  const GooogleAuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}