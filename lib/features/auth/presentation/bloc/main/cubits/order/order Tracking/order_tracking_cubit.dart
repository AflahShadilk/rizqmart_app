import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/order%20Tracking/order_tracking_state.dart';

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  OrderTrackingCubit(String status) : super(_resolve(status));

  static OrderTrackingState _resolve(String status) {
    final s = status.toLowerCase();
    if (s == 'cancelled') return OrderTrackingCancelled();
    int step = 0;
    if (s == 'processed' || s == 'processing') {
      step = 1;
    } else if (s == 'shipped') {
      step = 2;
    } else if (s.contains('out')) {
      step = 3;
    } else if (s == 'delivered') {
      step = 4;
    }
    return OrderTrackingActive(step);
  }
}