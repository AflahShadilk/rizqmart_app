import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';

/// Entity representing an overarching product model shown in category grids or explore feeds.
class ExploreEntities extends Equatable implements ShowProductEntities{
 @override final String id;
 @override final String name;
 @override final String brand;
 @override final String? description;
  final String category;
  final String categoryImage;
  @override
  final double discount;
  final bool features;
@override final List<Map<String,dynamic>>variantDetails;

  @override final double rating;
  @override final int reviewCount;

  const ExploreEntities({
    required this.id,
    required this.name,
    required this.brand,
    this.description,
    required this.category,
    required this.categoryImage,
    required this.discount,
    required this.features,
    required this.variantDetails,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        description,
        category,
        categoryImage,
        discount,
        features,
        variantDetails,
        rating,
        reviewCount,
      ];
}

/// Entity describing a product category and its visual representation logo.
class CategoryEntity extends Equatable{
  final String id;
  final String categoryName;
  final String logoUrl;

  const CategoryEntity({required this.id,required this.categoryName,required this.logoUrl});
  @override

  List<Object?> get props => [id,categoryName,logoUrl];
}