import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';

class PaymentFirestoreModel extends PaymentEntity {
  final String? approvalUrl;
  
  PaymentFirestoreModel({
    required String paymentId,
    required String orderId,
    required String userId,
    required double amount,
    required String method,
    required String status,
    required DateTime createdAt,
    String? transactionId,
    this.approvalUrl,
  }) : super(
          paymentId: paymentId,
          orderId: orderId,
          userId: userId,
          amount: amount,
          method: method,
          status: status,
          createdAt: createdAt,
          transactionId: transactionId,
        );

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