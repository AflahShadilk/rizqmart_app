import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';

class GetUserOrdersUsecase {
  final OrderRepository repository;

  GetUserOrdersUsecase(this.repository);

  Future<List<OrderEntities>> call() async {
    return await repository.getUserOrders();
  }
}