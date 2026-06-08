import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/data/model/main/wish_fire_model.dart';

/// Remote data source responsible for persisting user product wishlists within Firestore.
class WishListDataSource {
  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;

  CollectionReference? _collection(String userId){
    if (userId.isEmpty) return null;
    return firebaseFirestore.collection('users').doc(userId).collection('wishList');
  }

  Future<void>addToWishList(String userId,String productId,WishFireModel model)async{
    final collection = _collection(userId);
    if (collection == null) throw Exception('User not logged in');
    await collection.doc(productId).set(model.toMap());
  }

   Future<void>deleteFrmWishList(String userId,String productId)async{
    final collection = _collection(userId);
    if (collection == null) throw Exception('User not logged in');
    await collection.doc(productId).delete();
  }

  Future<bool>checkInWishList(String userId,String productId)async{
    final collection = _collection(userId);
    if (collection == null) return false;
    final doc=await collection.doc(productId).get();
    return doc.exists;
  }

  Stream<List<WishFireModel>> getWishList(String userId){
    final collection = _collection(userId);
    if (collection == null) return Stream.value([]);
    return collection.orderBy('addedAt',descending: true).snapshots().map((snap)=>snap.docs.map((doc)=>WishFireModel.fromFireStore(doc)).toList());                        
  }
}