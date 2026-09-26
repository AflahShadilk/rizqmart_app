import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/order_repository.dart';

/// Use case for fetching the complete history of orders placed by the current user.
class GetUserOrdersUsecase {
  final OrderRepository repository;

  GetUserOrdersUsecase(this.repository);

  Future<Either<Failure, List<OrderEntities>>> call() async {
    return await repository.getUserOrders();
  }
}