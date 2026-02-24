import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';

class GetUserOrdersUsecase {
  final OrderRepository repository;

  GetUserOrdersUsecase(this.repository);

  Future<Either<Failure, List<OrderEntities>>> call() async {
    return await repository.getUserOrders();
  }
}