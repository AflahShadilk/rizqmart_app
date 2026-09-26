import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/data/model/main/dash_firestore_model.dart';

/// Remote data source responsible for streaming and retrieving initial product data for the main dashboard.
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
             
             throw Exception("Product not found");
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
