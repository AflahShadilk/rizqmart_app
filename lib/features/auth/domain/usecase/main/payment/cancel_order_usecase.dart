import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';

class CancelPaymentOrderUseCase {
  final PaymentRepository repo;
  CancelPaymentOrderUseCase(this.repo);

  Future<PaymentEntity> call(String orderId) async {
    return await repo.cancelOrder(orderId);
  }
}
