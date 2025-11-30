import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';

class CartFirestoreModel extends CartEntities {
  const CartFirestoreModel(
      {required super.id,
      required super.name,
      required super.brand,
      required super.description,
      required super.variantDetails,
      required super.count,
      required super.variantIndex,
      required super.userId});

      factory CartFirestoreModel.fromFireStore(DocumentSnapshot snapShot){
        final data=snapShot.data() as Map<String,dynamic>;
        return CartFirestoreModel(
          id: snapShot.id, 
          name:data['name']??'', 
          brand: data['brand']??'',
          description: data['description']??'',
          variantDetails: List<Map<String,dynamic>>.from(data['variantDetails']??[]), 
          count: (data['count']??1).toInt(), 
          variantIndex: (data['variantIndex'] ?? 0).toInt(  ), 
          userId: data['userId']??''
          );
      }

    Map<String,dynamic>toMap(){
      return{
        'name': name,
        'brand':brand,
      'variantDetails': variantDetails,
      'count': count,
      'variantIndex': variantIndex,
      'userId': userId,
      };
    }  
}
