import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
class ExploreModel extends ExploreEntities {
  const ExploreModel(
      {required super.id,
      required super.name,
      required super.brand,
      required super.category,
      required super.categoryImage,
      required super.discount,
      required super.features,
      required super.variantDetails,
      super.rating,
      super.reviewCount,
      });

  factory ExploreModel.fromFireStore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    List<Map<String,dynamic>> variantDetails=[];
    if(data['variantDetails']!=null&&data['variantDetails'] is List){
     try{
       variantDetails=List<Map<String,dynamic>>.from(data['variantDetails']);
     }catch(e){
      variantDetails=[];
     }
    }
    return ExploreModel(
        id: snapshot.id,
        name: data['name'] ?? '',
        brand: data['brand'] ?? '',
        category: data['category'] ?? '',
        categoryImage: data['categoryImage'] ?? '',
        discount: (data['discount']??0.0).toDouble(),
        features: data['features']??false,
        variantDetails: variantDetails,
        rating: (data['rating'] ?? 0).toDouble(),
        reviewCount: data['reviewCount'] ?? 0,
        );
  }
}
class CategoryModel extends CategoryEntity {
  const CategoryModel(
      {required super.id, required super.categoryName, required super.logoUrl});

  factory CategoryModel.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final rawUrl = data['logoUrl']
        ?? data['logoURL']
        ?? data['image']
        ?? data['imageUrl']
        ?? data['imageURL']
        ?? data['categoryImage']
        ?? data['categoryImageUrl']
        ?? data['logo']
        ?? '';
    return CategoryModel(
        id: doc.id,
        categoryName: data['name'] ?? data['categoryName'] ?? '',
        logoUrl: rawUrl.toString().trim());
  }
}
