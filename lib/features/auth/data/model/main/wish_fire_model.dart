import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';

class WishFireModel extends WishListEntities {
  const WishFireModel(
      {required super.id,
      required super.name,
      required super.brand,
      required super.variantDetails,
      super.addedAt});

  factory WishFireModel.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WishFireModel(
        id: doc.id,
        name: data['name'] ?? '',
        brand: data['brand']??"",
        variantDetails:List<Map<String, dynamic>>.from(data['variantDetails'] ?? []),
            
        addedAt: (data['addedAt']as Timestamp?)?.toDate());
  }

  Map<String,dynamic>toMap(){
    return{
    'name':name,
    'brand':brand,
    'variantDetails':variantDetails,
    'addedAt':addedAt!=null?Timestamp.fromDate(addedAt!):FieldValue.serverTimestamp()
    };
  }
}
