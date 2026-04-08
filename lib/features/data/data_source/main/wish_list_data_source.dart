import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/data/model/main/wish_fire_model.dart';

/// Remote data source responsible for persisting user product wishlists within Firestore.
class WishListDataSource {
  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;

  CollectionReference _collection(String userId){
    return firebaseFirestore.collection('users').doc(userId).collection('wishList');
  }

  Future<void>addToWishList(String userId,String productId,WishFireModel model)async{
    await _collection(userId).doc(productId).set(model.toMap());
  }

  Future<void>deleteFrmWishList(String userId,String productId)async{
    await _collection(userId).doc(productId).delete();
  }

  Future<bool>checkInWishList(String userId,String productId)async{
    final doc=await _collection(userId).doc(productId).get();
    return doc.exists;
  }

  Stream<List<WishFireModel>> getWishList(String userId){
    return _collection(userId).orderBy('addedAt',descending: true).snapshots().map((snap)=>snap.docs.map((doc)=>WishFireModel.fromFireStore(doc)).toList());                        
  }
}