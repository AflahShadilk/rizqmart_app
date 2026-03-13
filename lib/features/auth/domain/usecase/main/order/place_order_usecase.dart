

import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';
class PlaceOrderUsecase {
  final OrderRepository repository;

  PlaceOrderUsecase(this.repository);

  Future<Either<Failure, String>> call(OrderEntities order) async {
    return await repository.placeOrder(order);
  }
}