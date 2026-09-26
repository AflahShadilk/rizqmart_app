/// Base abstract class representing the state of the forgot password flow.
abstract class ForgotState {}
class ForgotInitial extends ForgotState{}
class ForgotLoading extends ForgotState{}
class ForgotSuccess extends ForgotState{
  final String message;
  ForgotSuccess(this.message);
}
class ForgotFailure extends ForgotState{
  final String error;
  ForgotFailure(this.error);
}