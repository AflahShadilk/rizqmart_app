import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String paymentId;
  final String orderId;
  final String userId;
  final double amount;
  final String method;
  final String status;
  final DateTime createdAt;
  final String? transactionId;      
  final String? refundReason;       
  final DateTime? refundedAt;    


  const PaymentEntity(
      {required this.paymentId,
      required this.orderId,
      required this.userId,
      required this.amount,
      required this.method,
      required this.status,
      required this.createdAt,
      this.transactionId,
      this.refundReason,
      this.refundedAt,
      
      });

  @override
  List<Object?> get props =>
      [paymentId, orderId, userId, amount, method, status, createdAt,transactionId,refundReason,refundedAt];
}
