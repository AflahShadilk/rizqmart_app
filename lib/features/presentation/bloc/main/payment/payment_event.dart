import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/domain/entities/main/saved_card_entity.dart';

/// Base abstract class for triggering payment initialization, processing, cancellations, and refunds.
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitializePaymentEvent extends PaymentEvent {
  final OrderEntities order;
  final String paymentMethod;
  final SavedCardEntity? savedCard;

  const InitializePaymentEvent({
    required this.order,
    required this.paymentMethod,
    this.savedCard,
  });

  @override
  List<Object?> get props => [order, paymentMethod, savedCard];
}

class ProcessPaymentEvent extends PaymentEvent {
  final String paymentMethod;

  const ProcessPaymentEvent(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class ConfirmPaymentEvent extends PaymentEvent {
  final String paypalOrderId;

  const ConfirmPaymentEvent(this.paypalOrderId);

  @override
  List<Object?> get props => [paypalOrderId];
}

class CancelPaymentEvent extends PaymentEvent {
  const CancelPaymentEvent();
}

class RefundPaymentEvent extends PaymentEvent {
  final String orderId;
  final double amount;

  const RefundPaymentEvent({
    required this.orderId,
    required this.amount,
  });

  @override
  List<Object?> get props => [orderId, amount];
}
