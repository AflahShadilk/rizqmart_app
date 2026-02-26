import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';

/// Use case for cancelling an order specifically within the payment processing flow.
class CancelPaymentOrderUseCase {
  final PaymentRepository repo;
  CancelPaymentOrderUseCase(this.repo);

  Future<Either<Failure, PaymentEntity>> call(String orderId) async {
    return await repo.cancelOrder(orderId);
  }
}
