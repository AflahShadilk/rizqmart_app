import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';

class DashFirestoreModel extends ProductEntities {
  const DashFirestoreModel(
      {required super.id,
      required super.name,
      super.description,
      // required super.price,
      required super.category,
      required super.brand,
      // super.quantity,
      super.discount,
      // required super.variant,
      // required super.imageUrl,

      super.feature,
     required super.variantDetails,
     super.rating,
     super.reviewCount,
      });

  factory DashFirestoreModel.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    List<Map<String,dynamic>>variantDetails=[];
  try{
    if(data['variantDetails']!=null&&data['variantDetails'] is List){
      variantDetails=List<Map<String,dynamic>>.from(  data['variantDetails']);
    }
  }catch(e){
   variantDetails=[];
  }
    return DashFirestoreModel(
        id: doc.id,
        name: data['name'] ?? "",
        description: data['description']??"",
        // price: (data['price'] ?? 0).toDouble(),
        category: data['category'] ?? '',
        brand: data['brand'] ?? '',
        // quantity: (data['quantity'] ?? 0).toDouble(),
        discount: (data['discount'] ?? 0).toDouble(),
        // variant: List<String>.from(data['variant'] ?? []),
        // imageUrl: List<String>.from(data['imageUrls'] ?? []),
        feature: data['feature'] ?? false,
        variantDetails: variantDetails,
        rating: (data['rating'] ?? 0).toDouble(),
        reviewCount: data['reviewCount'] ?? 0,
        );
  }

  Map<String, dynamic> toFireStore() {
    return {
      
      'name': name,
      'description':description,
      // 'price': price,
      
      'category': category,
      'brand': brand,
      // 'quantity':quantity,
      'discount':discount,
      // 'variant':variant,
      // 'imageUrl':imageUrl,
      'feature':feature,
      'variantDetails':variantDetails,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
