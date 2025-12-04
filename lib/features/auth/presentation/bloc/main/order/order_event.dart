import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class PlaceOrderEvent extends OrderEvent {
  final OrderEntities order;

  const PlaceOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

class GetUserOrdersEvent extends OrderEvent {
  const GetUserOrdersEvent();
}

class CancelOrderEvent extends OrderEvent {
  final String orderId;

  const CancelOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
