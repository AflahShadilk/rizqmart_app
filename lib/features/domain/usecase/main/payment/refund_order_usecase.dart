import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/payment_repository.dart';

/// Use case for processing a financial refund for a previously completed order.
class RefundOrderUseCase {
  final PaymentRepository repo;
  
  RefundOrderUseCase(this.repo);

  Future<Either<Failure, PaymentEntity>> call(String orderId, double amount) async {
    return await repo.refundOrder(orderId, amount);
  }
}
