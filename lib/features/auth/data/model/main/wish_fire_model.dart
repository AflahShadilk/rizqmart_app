import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';

class WishFireModel extends WishListEntities {
  const WishFireModel(
      {required super.id,
      required super.name,
      required super.brand,
      required super.variantDetails,
      required super.variantIndex,
      required super.userId,
      super.addedAt,
      super.discount});

  factory WishFireModel.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WishFireModel(
        id: doc.id,
        name: data['name'] ?? '',
        brand: data['brand']??"",
        variantDetails:List<Map<String, dynamic>>.from(data['variantDetails'] ?? []),
        variantIndex: data['variantIndex']??0,
        userId: data['userId']??'',
        addedAt: (data['addedAt']as Timestamp?)?.toDate(),
        discount: (data['discount'] is int)
            ? (data['discount'] as int).toDouble()
            : (data['discount'] as double?),
    );
  }

  Map<String,dynamic>toMap(){
    return{
    'name':name,
    'brand':brand,
    'variantDetails':variantDetails,
    'variantIndex': variantIndex,
    'userId'   :userId,
    'addedAt':addedAt!=null?Timestamp.fromDate(addedAt!):FieldValue.serverTimestamp(),
    'discount': discount,
    };
  }
}
