import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/order/cancel_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/order/get_user_orders_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/order/place_order_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_state.dart';

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
    try {
      final orderId = await placeOrderUsecase.call(event.order);
      emit(OrderSuccessState(orderId: orderId));
    } catch (e) {
      emit(OrderErrorState('Failed to place order: ${e.toString()}'));
    }
  }

  Future<void> _onGetUserOrders(
    GetUserOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoadingState());
    try {
      final orders = await getUserOrdersUsecase.call();
      emit(OrdersLoadedState(orders));
    } catch (e) {
      emit(OrderErrorState('Failed to get orders: ${e.toString()}'));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoadingState());
    try {
      await cancelOrderUsecase.call(event.orderId);
      emit(const OrderSuccessState(
        orderId: '',
        message: 'Order cancelled successfully',
      ));
    } catch (e) {
      emit(OrderErrorState('Failed to cancel order: ${e.toString()}'));
    }
  }
}