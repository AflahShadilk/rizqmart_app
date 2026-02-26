import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';

/// Abstract repository for managing the user's e-commerce order lifecycle.
abstract class OrderRepository {
  Future<Either<Failure, String>> placeOrder(OrderEntities order);
  Future<Either<Failure, List<OrderEntities>>> getUserOrders();
  Future<Either<Failure, OrderEntities>> getOrderById(String orderId);
  Future<Either<Failure, void>> cancelOrder(String orderId);
}
