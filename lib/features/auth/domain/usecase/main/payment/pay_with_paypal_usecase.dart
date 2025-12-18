import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';

class PayWithPayPalUseCase {
  final PaymentRepository repo;
  PayWithPayPalUseCase(this.repo);

  Future<PaymentEntity> call(OrderEntities order) async {
    return await repo.payWithPaypal(order);
  }
}
