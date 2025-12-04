import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';

class CancelOrderUsecase {
  final OrderRepository repository;

  CancelOrderUsecase(this.repository);

  Future<void> call(String orderId) async {
    return await repository.cancelOrder(orderId);
  }
}