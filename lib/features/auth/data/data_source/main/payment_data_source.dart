import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/data/model/main/payment_firestore_model.dart';

class PaymentDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get currentUserId => auth.currentUser?.uid ?? '';

  // Create new payment record
  Future<String> createPayment(PaymentFirestoreModel payment) async {
    try {
      final docRef = await firestore.collection('payments').add(payment.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  // Get payment by paymentId
  Future<PaymentFirestoreModel?> getPaymentById(String paymentId) async {
    try {
      final doc = await firestore.collection('payments').doc(paymentId).get();
      if (!doc.exists) return null;
      return PaymentFirestoreModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get payment: $e');
    }
  }


  // This is used in cancelOrder() and refundOrder()
  Future<PaymentFirestoreModel?> getPaymentByOrderId(String orderId) async {
    try {
      final query = await firestore
          .collection('payments')
          .where('orderId', isEqualTo: orderId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;
      return PaymentFirestoreModel.fromFirestore(query.docs.first);
    } catch (e) {
      throw Exception('Failed to get payment by order ID: $e');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(
    String paymentId,
    String status, {
    String? transactionId,
  }) async {
    try {
      final updateData = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (transactionId != null) {
        updateData['transactionId'] = transactionId;
      }
      await firestore.collection('payments').doc(paymentId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  // Mark payment as refunded
  Future<void> refundPayment(String paymentId, String reason) async {
    try {
      await firestore.collection('payments').doc(paymentId).update({
        'status': 'refunded',
        'refundReason': reason,
        'refundedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to refund payment: $e');
    }
  }

  // Get all payments for user
  Future<List<PaymentFirestoreModel>> getUserPayments() async {
    try {
      final query = await firestore
          .collection('payments')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => PaymentFirestoreModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user payments: $e');
    }
  }
}