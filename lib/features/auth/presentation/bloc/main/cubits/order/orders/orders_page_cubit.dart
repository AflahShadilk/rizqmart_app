import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_state.dart';
import 'orders_page_state.dart';

/// Cubit linking the generic OrderBloc with specific UI load/empty/error states.
class OrdersPageCubit extends Cubit<OrdersPageState> {
  final OrderBloc orderBloc;
  late final StreamSubscription _subscription;

  OrdersPageCubit({required this.orderBloc}) : super(OrdersPageInitial()) {
    _subscription = orderBloc.stream.listen(_onOrderBlocState);
    orderBloc.add(const GetUserOrdersEvent());
  }

  void _onOrderBlocState(OrderState state) {
    if (state is OrderLoadingState) {
      emit(OrdersPageLoading());
    } else if (state is OrdersLoadedState) {
      if (state.orders.isEmpty) {
        emit(OrdersPageEmpty());
      } else {
        emit(OrdersPageLoaded(state.orders));
      }
    } else if (state is OrderSuccessState) {
      emit(OrdersPageCancelSuccess(state.message));
      orderBloc.add(const GetUserOrdersEvent());
    } else if (state is OrderErrorState) {
      emit(OrdersPageError(state.message));
    }
  }

  void retryLoad() {
    orderBloc.add(const GetUserOrdersEvent());
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}