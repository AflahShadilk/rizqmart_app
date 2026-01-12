import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/data/model/main/order_firestore_model.dart';

class OrderDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get currentUserId => auth.currentUser?.uid ?? '';

  Future<String> placeOrder(OrderFirestoreModel order) async {
    try {
      print('🔵 Creating order for user: ${order.userId}');
      
      final docRef = await firestore.collection('orders').add({
        ...order.toMap(),
        'paymentStatus': 'succeeded',
        // ✅ ENSURE THESE ARE SAVED
        'userName': order.userName,
        'userEmail': order.userEmail,
        'userPhone': order.userPhone,
        'deliveryNotes': order.deliveryNotes,
      });
      
      print('✅ Order created: ${docRef.id}');
      print('📝 Customer: ${order.userName}');
      print('📍 Address: ${order.deliveryAddress}');
      
      // Clear cart after order
      await clearUserCart(order.userId);
      
      return docRef.id;
    } catch (e) {
      print('🔴 Error creating order: $e');
      throw Exception('Failed to place order: $e');
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
      await firestore.collection('orders').doc(orderId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }
}
