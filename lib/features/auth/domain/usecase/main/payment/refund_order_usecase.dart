import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';

class RefundOrderUseCase {
  final PaymentRepository repo;
  
  RefundOrderUseCase(this.repo);

  Future<PaymentEntity> call(String orderId, double amount) async {
    return await repo.refundOrder(orderId, amount);
  }
}
