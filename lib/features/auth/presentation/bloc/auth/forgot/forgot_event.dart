abstract class ForgotEvent {
 
}
class ForgotSubmitted extends ForgotEvent{
  final String emailId;
  ForgotSubmitted( this.emailId);
 
}