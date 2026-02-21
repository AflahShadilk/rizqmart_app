abstract class OrderTrackingState {}

class OrderTrackingActive extends OrderTrackingState {
  final int currentStep;
  OrderTrackingActive(this.currentStep);
}

class OrderTrackingCancelled extends OrderTrackingState {}