import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/payment/saved_card_entity.dart';

abstract class PaymentRepository {
  
  Future<OrderEntities> createOrder(OrderEntities order);
  Future<PaymentEntity> payWithStripe(OrderEntities order, {SavedCardEntity? savedCard}); 
  Future<PaymentEntity> payWithCOD(OrderEntities order);
  Future<PaymentEntity> cancelOrder(String orderId);
  Future<PaymentEntity> refundOrder(String orderId, double amount);
}