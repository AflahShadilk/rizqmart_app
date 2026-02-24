import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, OrderEntities>> createOrder(OrderEntities order);
  Future<Either<Failure, PaymentEntity>> payWithStripe(OrderEntities order, {SavedCardEntity? savedCard}); 
  Future<Either<Failure, PaymentEntity>> payWithCOD(OrderEntities order);
  Future<Either<Failure, PaymentEntity>> cancelOrder(String orderId);
  Future<Either<Failure, PaymentEntity>> refundOrder(String orderId, double amount);
}