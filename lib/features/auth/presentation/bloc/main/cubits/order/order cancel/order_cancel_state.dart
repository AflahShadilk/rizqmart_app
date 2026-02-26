/// Base abstract class describing the asynchronous state of canceling an order.
abstract class OrderCancelState {}

class OrderCancelInitial extends OrderCancelState {}

class OrderCancelConfirming extends OrderCancelState {}

class OrderCancelSuccess extends OrderCancelState {}