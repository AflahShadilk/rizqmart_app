import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/order/cancel_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/order/get_user_orders_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/order/place_order_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_state.dart';

/// Business logic overseeing order creation, history retrieval, and cancellations.
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrderUsecase placeOrderUsecase;
  final GetUserOrdersUsecase getUserOrdersUsecase;
  final CancelOrderUsecase cancelOrderUsecase;

  OrderBloc({
    required this.placeOrderUsecase,
    required this.getUserOrdersUsecase,
    required this.cancelOrderUsecase,
  }) : super(const OrderInitialState()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<GetUserOrdersEvent>(_onGetUserOrders);
    on<CancelOrderEvent>(_onCancelOrder);
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoadingState());
    final result = await placeOrderUsecase.call(event.order);
    result.fold(
      (failure) => emit(OrderErrorState('Failed to place order: ${failure.message}')),
      (orderId) => emit(OrderSuccessState(orderId: orderId)),
    );
  }

  Future<void> _onGetUserOrders(
    GetUserOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoadingState());
    final result = await getUserOrdersUsecase.call();
    result.fold(
      (failure) => emit(OrderErrorState('Failed to get orders: ${failure.message}')),
      (orders) => emit(OrdersLoadedState(orders)),
    );
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoadingState());
    final result = await cancelOrderUsecase.call(event.orderId);
    result.fold(
      (failure) => emit(OrderErrorState('Failed to cancel order: ${failure.message}')),
      (_) => emit(const OrderSuccessState(
        orderId: '',
        message: 'Order cancelled successfully',
      )),
    );
  }
}