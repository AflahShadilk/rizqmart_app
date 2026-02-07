import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/data/model/main/dash_firestore_model.dart';

class DashboardDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<List<DashFirestoreModel>> getAllProducts() {
    try {
      return firestore
          .collection('products')
          .snapshots()
          .map((snap) => snap.docs.map((doc) {
                return DashFirestoreModel.fromFireStore(doc);
              }).toList());
    } catch (e) {
      return const Stream.empty();
    }
  }

  Stream<DashFirestoreModel> getProductById(String id) {
    try {
      return firestore.collection('products').doc(id).snapshots().map((doc) {
        if (doc.exists) {
          return DashFirestoreModel.fromFireStore(doc);
        } else {
             // Handle case where document doesn't exist, though typically it should if we are on details page
             // Returning a default/empty model or throwing might be options.
             // For stream, we can just return what we have or handle error downstream.
             throw Exception("Product not found");
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
