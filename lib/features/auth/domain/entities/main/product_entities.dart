
import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';

class ProductEntities extends Equatable implements ShowProductEntities{

 @override final  String  id;
@override final String name;
@override final String? description;
 final String category;
@override final String brand;

 final double? discount;
 final bool? feature;
@override final List<Map<String,dynamic>> variantDetails;

 const ProductEntities({required this.id,required this.name,this.description,required this.category,required this.brand,this.discount,this.feature,required this.variantDetails});
@override
  
  List<Object?> get props => [id,name,description,category,brand,discount,feature,variantDetails];
}