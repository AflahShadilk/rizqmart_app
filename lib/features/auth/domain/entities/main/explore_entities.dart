import 'package:equatable/equatable.dart';

class ExploreEntities extends Equatable{
  final String id;
  final String name;
  final String brand;
  final String category;
  final String categoryImage;
  final double discount;
  final bool features;
final List<Map<String,dynamic>>variantDetails;

  const ExploreEntities({required this.id,required this.name,required this.brand,required this.category,required this.categoryImage,required this.discount,required this.features,required this.variantDetails});
  @override
  
  List<Object?> get props => [id,name,brand,category,categoryImage,discount,features,variantDetails];
}

class CategoryEntity extends Equatable{
  final String id;
  final String categoryName;
  final String logoUrl;

  const CategoryEntity({required this.id,required this.categoryName,required this.logoUrl});
  @override

  List<Object?> get props => [id,categoryName,logoUrl];
}