import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/order/order_event.dart';
import 'order_cancel_state.dart';

/// Cubit firing cancellation events to OrderBloc and storing UI feedback state.
class OrderCancelCubit extends Cubit<OrderCancelState> {
  final OrderBloc orderBloc;

  OrderCancelCubit({required this.orderBloc}) : super(OrderCancelInitial());

  void confirmCancel(String orderId) {
    emit(OrderCancelConfirming());
    orderBloc.add(CancelOrderEvent(orderId));
    emit(OrderCancelSuccess());
  }
}