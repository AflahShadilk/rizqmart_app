import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';

abstract class OrderRepository {
  Future<String> placeOrder(OrderEntities order);
  Future<List<OrderEntities>> getUserOrders();
  Future<OrderEntities> getOrderById(String orderId);
  Future<void> cancelOrder(String orderId);
}
