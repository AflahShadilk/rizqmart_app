/// Base abstract class designating the current active progress phase of order tracking.
abstract class OrderTrackingState {}

class OrderTrackingActive extends OrderTrackingState {
  final int currentStep;
  OrderTrackingActive(this.currentStep);
}

class OrderTrackingCancelled extends OrderTrackingState {}