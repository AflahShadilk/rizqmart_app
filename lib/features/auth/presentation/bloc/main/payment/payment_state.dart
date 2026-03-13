import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitialState extends PaymentState {
  const PaymentInitialState();
}

class PaymentLoadingState extends PaymentState {
  final String message;
  const PaymentLoadingState(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentMethodSelectedState extends PaymentState {
  final String paymentMethod;
  final OrderEntities order;

  const PaymentMethodSelectedState({
    required this.paymentMethod,
    required this.order,
  });

  @override
  List<Object?> get props => [paymentMethod, order];
}

class PaymentSuccessState extends PaymentState {
  final String orderId;
  final PaymentEntity? payment;
  final OrderEntities order;

  const PaymentSuccessState({
    required this.orderId,
    required this.payment,
    required this.order,
  });

  @override
  List<Object?> get props => [orderId, payment, order];
}

class PaymentFailedState extends PaymentState {
  final String message;
  const PaymentFailedState(this.message);

  @override
  List<Object?> get props => [message];
}

class CancellationSuccessState extends PaymentState {
  final String orderId;
  final PaymentEntity cancelledPayment;
  final double refundAmount;

  const CancellationSuccessState({
    required this.orderId,
    required this.cancelledPayment,
    required this.refundAmount,
  });

  @override
  List<Object?> get props => [orderId, cancelledPayment, refundAmount];
}

class RefundSuccessState extends PaymentState {
  final String message;
  const RefundSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
