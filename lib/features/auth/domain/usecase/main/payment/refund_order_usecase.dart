import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';

class RefundOrderUseCase {
  final PaymentRepository repo;
  
  RefundOrderUseCase(this.repo);

  Future<Either<Failure, PaymentEntity>> call(String orderId, double amount) async {
    return await repo.refundOrder(orderId, amount);
  }
}
