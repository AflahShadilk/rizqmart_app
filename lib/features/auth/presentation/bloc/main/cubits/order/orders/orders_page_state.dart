import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';

/// Base abstract class determining whether the user's order list is loading or populated.
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