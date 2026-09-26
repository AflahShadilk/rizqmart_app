import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/payment_repository.dart';

/// Use case for initializing a new order record before processing payment.
class CreateOrderUsecase {
  final PaymentRepository repo;
  const CreateOrderUsecase(this.repo);
  Future<Either<Failure, OrderEntities>> call(OrderEntities order) async {
    return await repo.createOrder(order);
  }
}