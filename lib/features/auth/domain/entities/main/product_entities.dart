
import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';

class ProductEntities extends Equatable implements ShowProductEntities{

 @override final  String  id;
@override final String name;
@override final String? description;
 final String category;
@override final String brand;

 @override
  final double? discount;
 final bool? feature;
@override final List<Map<String,dynamic>> variantDetails;
 @override final double rating;
 @override final int reviewCount;

 const ProductEntities({required this.id,required this.name,this.description,required this.category,required this.brand,this.discount,this.feature,required this.variantDetails,this.rating=0.0,this.reviewCount=0});
@override
  
  List<Object?> get props => [id,name,description,category,brand,discount,feature,variantDetails,rating,reviewCount];
}