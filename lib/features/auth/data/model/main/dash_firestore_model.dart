import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';

class DashFirestoreModel extends ProductEntities {
  const DashFirestoreModel(
      {required super.id,
      required super.name,
      super.description,
      required super.category,
      required super.brand,
 
      super.discount,
      
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
        category: data['category'] ?? '',
        brand: data['brand'] ?? '',
        discount: (data['discount'] ?? 0).toDouble(),
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
      
      'category': category,
      'brand': brand,
      'discount':discount,
      'feature':feature,
      'variantDetails':variantDetails,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
