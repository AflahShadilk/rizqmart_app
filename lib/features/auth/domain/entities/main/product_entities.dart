
import 'package:equatable/equatable.dart';

class ProductEntities extends Equatable{
 final  String  id;
 final String name;
 final String? description;
 final String category;
 final String brand;

 final double? discount;
 final bool? feature;
final List<Map<String,dynamic>>? variantDetails;

 const ProductEntities({required this.id,required this.name,this.description,required this.category,required this.brand,this.discount,this.feature,this.variantDetails});
@override
  
  List<Object?> get props => [id,name,description,category,brand,discount,feature,variantDetails];
}