import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Data source handling all shopping cart interactions with Firebase Firestore.
class CartDataSource {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get currentUserId => auth.currentUser?.uid ?? '';

  CollectionReference cartCollectionReference(String userId) {
    return fireStore.collection('users').doc(userId).collection('cart');
  }

  Future<void> addToCart(
      {required String id,
      required String name,
      required String brand,
      required String? description,
      required List<Map<String, dynamic>> variantDetails,
      required int count,
      required int variantIndex,
      required String userId,
      double? discount}) async {
    try {
      final cartItemId = '${id}_variant_$variantIndex';

      final cartData = {
        'id': id,
        'name': name,
        'brand': brand,
        'description': description,
        'variantDetails': variantDetails,
        'count': count,
        'variantIndex': variantIndex,
        'userId': userId,
        'discount': discount,
        'addedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp()
      };
      await cartCollectionReference(userId)
          .doc(cartItemId)
          .set(cartData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to add to cart:$e');
    }
  }

  Stream<List<DocumentSnapshot>> getCartItems(String userId) {
    try {
      return cartCollectionReference(userId)
          .orderBy('addedAt', descending: true)
          .snapshots()
          .map((snap) => snap.docs);
    } catch (e) {
      throw Exception('Failed to get cart items : $e');
    }
  }

  Future<void> removeFromCart({
    required String userId,
    required String cartItemId,
  }) async {
    try {
      await cartCollectionReference(userId).doc(cartItemId).delete();
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  Future<void> updateQuantity(
      {required String userId,
      required String cartItemId,
      required int count}) async {
    try {
      if (count <= 0) {
        await removeFromCart(userId: userId, cartItemId: cartItemId);
        return;
      }
      await cartCollectionReference(userId)
          .doc(cartItemId)
          .update({'count': count, 'updatedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }

Future<void> incrementQuantity(
    {required String userId, required String cartItemId}) async {
  try {
    final doc = await cartCollectionReference(userId).doc(cartItemId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>?;
      final currentCount = (data?['count'] ?? 1) as int;
      if (currentCount < 20) {
        await cartCollectionReference(userId).doc(cartItemId).update({
          'count': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp()
        });
      }
    }
  } catch (e) {
    throw Exception('Failed to increment quantity: $e');
  }
}

Future<void> decrementQuantity(
    {required String userId, required String cartItemId}) async {
  try {
    final doc = await cartCollectionReference(userId).doc(cartItemId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>?;
      final currentCount = (data?['count'] ?? 1) as int;
      
      if (currentCount <= 1) {
        await removeFromCart(userId: userId, cartItemId: cartItemId);
      } else {
        await cartCollectionReference(userId).doc(cartItemId).update({
          'count': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } else {
    }
  } catch (e) {
    throw Exception('Failed to decrement quantity: $e');
  }
}

  Future<void> clearCart(String userId) async {
    try {
      final batch = fireStore.batch();
      final snapshot = await cartCollectionReference(userId).get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  Future<bool> isInCart({
    required String userId,
    required String cartItemId,
  }) async {
    try {
      final doc = await cartCollectionReference(userId).doc(cartItemId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
