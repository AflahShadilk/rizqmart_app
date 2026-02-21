import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_status_state.dart';

class OrderStatusCubit extends Cubit<OrderStatusState> {
  OrderStatusCubit(String status) : super(_resolve(status));

  static OrderStatusState _resolve(String status) {
    switch (status.toLowerCase().trim()) {
      case 'pending':
      case 'pending_payment':
        return const OrderStatusState(label: 'Pending', color: Colors.orange);
      case 'confirmed':
        return const OrderStatusState(label: 'Confirmed', color: Color(0xFF1565C0));
      case 'processing':
      case 'processed':
        return const OrderStatusState(label: 'Processing', color: Colors.blue);
      case 'shipped':
        return const OrderStatusState(label: 'Shipped', color: Colors.purple);
      case 'out_for_delivery':
      case 'out for delivery':
        return const OrderStatusState(label: 'Out for Delivery', color: Colors.deepPurple);
      case 'delivered':
        return const OrderStatusState(label: 'Delivered', color: Colors.green);
      case 'cancelled':
      case 'canceled':
        return const OrderStatusState(label: 'Cancelled', color: Colors.red);
      case 'refunded':
        return const OrderStatusState(label: 'Refunded', color: Colors.teal);
      case 'failed':
        return const OrderStatusState(label: 'Failed', color: Colors.red);
      default:
        return OrderStatusState(
          label: status[0].toUpperCase() + status.substring(1),
          color: Colors.grey,
        );
    }
  }
}