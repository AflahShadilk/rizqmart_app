import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/order_entities.dart';

/// Base abstract class representing the success, error, or loading states of orders.
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitialState extends OrderState {
  const OrderInitialState();
}

class OrderLoadingState extends OrderState {
  const OrderLoadingState();
}

class OrderSuccessState extends OrderState {
  final String orderId;
  final String message;

  const OrderSuccessState({
    required this.orderId,
    this.message = 'Order placed successfully!',
  });

  @override
  List<Object?> get props => [orderId, message];
}

class OrdersLoadedState extends OrderState {
  final List<OrderEntities> orders;

  const OrdersLoadedState(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderErrorState extends OrderState {
  final String message;

  const OrderErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
