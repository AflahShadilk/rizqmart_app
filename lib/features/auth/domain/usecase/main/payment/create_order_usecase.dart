import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';

class CreateOrderUsecase {
  final PaymentRepository repo;
  const CreateOrderUsecase(this.repo);
  Future<OrderEntities>call(OrderEntities order){
    return repo.createOrder(order);
  }
}