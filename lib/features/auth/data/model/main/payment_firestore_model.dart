import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';

class PaymentFirestoreModel extends PaymentEntity {
  const PaymentFirestoreModel({
    required super.paymentId,
    required super.orderId,
    required super.userId,
    required super.amount,
    required super.method,
    required super.status,
    required super.createdAt,
  });

  factory PaymentFirestoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentFirestoreModel(
      paymentId: doc.id,
      orderId: data['orderId'] ?? '',
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      method: data['method'] ?? 'unknown',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'method': method,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
