import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/data/model/main/order_firestore_model.dart';
class OrderDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get currentUserId => auth.currentUser?.uid ?? '';

  Future<String> placeOrder(OrderFirestoreModel order) async {
    try {
      DocumentReference docRef;
      if (order.orderId.isNotEmpty) {
        docRef = firestore.collection('orders').doc(order.orderId);
      } else {
        docRef = firestore.collection('orders').doc();
      }

      await docRef.set({
        ...order.toMap(),
        'orderId': docRef.id,
        'userName': order.userName,
        'userEmail': order.userEmail,
        'userPhone': order.userPhone,
        'deliveryNotes': order.deliveryNotes,
      }, SetOptions(merge: true));
      
      return docRef.id;
    } catch (e) {

      throw Exception('Failed to place order: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  Future<void> clearUserCart(String userId) async {
    try {
      final batch = firestore.batch();
      final cartRef =
          firestore.collection('users').doc(userId).collection('cart');

      final snapshot = await cartRef.get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  Future<List<DocumentSnapshot>> getUserOrders() async {
    try {
      final snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs;
    } catch (e) {
      if (e.toString().contains('requires an index')) {

      }
      throw Exception('Failed to get orders: $e');
    }
  }

  Future<DocumentSnapshot> getOrderById(String orderId) async {
    try {
      return await firestore.collection('orders').doc(orderId).get();
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await firestore.runTransaction((transaction) async {
        final orderRef = firestore.collection('orders').doc(orderId);
        final orderDoc = await transaction.get(orderRef);

        if (!orderDoc.exists) {
          throw Exception('Order does not exist!');
        }

        final orderData = orderDoc.data() as Map<String, dynamic>;
        final currentStatus = orderData['status'] as String? ?? 'unknown';

        if (currentStatus == 'cancelled') {
          throw Exception('Order is already cancelled');
        }

        final userId = orderData['userId'] as String;
        final totalCost = (orderData['totalCost'] as num).toDouble();

        
        final userRef = firestore.collection('users').doc(userId);
        final userDoc = await transaction.get(userRef);

        transaction.update(orderRef, {
          'status': 'cancelled',
          'cancelledAt': FieldValue.serverTimestamp(),
        });

        if (userDoc.exists) {
          final currentBalance = (userDoc.data() as Map<String, dynamic>)['walletBalance'] as num? ?? 0.0;
          transaction.update(userRef, {
            'walletBalance': currentBalance + totalCost,
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }
}
