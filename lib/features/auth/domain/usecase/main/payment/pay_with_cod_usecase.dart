import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';
class PayWithCODUseCase {
  final PaymentRepository repo;
  PayWithCODUseCase(this.repo);

  Future<Either<Failure, PaymentEntity>> call(OrderEntities order) async {
    return await repo.payWithCOD(order);
  }
}
