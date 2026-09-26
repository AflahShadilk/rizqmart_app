import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/domain/entities/main/payment_entity.dart';

/// Data model for payment transactions, adapting `PaymentEntity` for Firestore storage.
class PaymentFirestoreModel extends PaymentEntity {
  final String? approvalUrl;
  
  const PaymentFirestoreModel({
    required super.paymentId,
    required super.orderId,
    required super.userId,
    required super.amount,
    required super.method,
    required super.status,
    required super.createdAt,
    super.transactionId,
    this.approvalUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'method': method,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      if (transactionId != null) 'transactionId': transactionId,
      if (approvalUrl != null) 'approvalUrl': approvalUrl,
    };
  }

  factory PaymentFirestoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentFirestoreModel(
      paymentId: doc.id,
      orderId: data['orderId'] ?? '',
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      method: data['method'] ?? '',
      status: data['status'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      transactionId: data['transactionId'],
      approvalUrl: data['approvalUrl'],
    );
  }
} 