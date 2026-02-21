import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';

abstract class OrdersPageState {}

class OrdersPageInitial extends OrdersPageState {}

class OrdersPageLoading extends OrdersPageState {}

class OrdersPageLoaded extends OrdersPageState {
  final List<OrderEntities> orders;
  OrdersPageLoaded(this.orders);
}

class OrdersPageEmpty extends OrdersPageState {}

class OrdersPageError extends OrdersPageState {
  final String message;
  OrdersPageError(this.message);
}

class OrdersPageCancelSuccess extends OrdersPageState {
  final String message;
  OrdersPageCancelSuccess(this.message);
}