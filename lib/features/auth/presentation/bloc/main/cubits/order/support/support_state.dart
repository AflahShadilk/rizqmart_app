/// Base abstract class storing the status of launching an external support handler (url/email).
abstract class SupportState {}

class SupportInitial extends SupportState {}

class SupportLaunching extends SupportState {}

class SupportLaunchSuccess extends SupportState {}

class SupportLaunchFailure extends SupportState {}