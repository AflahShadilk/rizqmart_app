/// Base abstract class for forgot password events.
abstract class ForgotEvent {
 
}
class ForgotSubmitted extends ForgotEvent{
  final String emailId;
  ForgotSubmitted( this.emailId);
 
}