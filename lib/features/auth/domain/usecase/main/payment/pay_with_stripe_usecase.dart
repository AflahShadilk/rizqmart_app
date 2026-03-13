import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';
class PayWithStripeUseCase {
  final PaymentRepository repo;
  PayWithStripeUseCase(this.repo);

  Future<Either<Failure, PaymentEntity>> call(OrderEntities order, {SavedCardEntity? savedCard}) async {
    return await repo.payWithStripe(order, savedCard: savedCard);
  }
}
