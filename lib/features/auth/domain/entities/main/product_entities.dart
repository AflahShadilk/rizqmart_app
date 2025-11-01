
import 'package:equatable/equatable.dart';

class ProductEntities extends Equatable{
 final  String  id;
 final String name;
 final double price;
 final String? description;
 final String category;
 final String brand;
 final double? quantity;
 final double? discount;
 final List<String>variant;
 final List<String>imageUrl;
 final bool? feature;

 const ProductEntities({required this.id,required this.name,this.description,required this.price,required this.category,required this.brand,this.quantity,this.discount,required this.variant,required this.imageUrl,this.feature});
@override
  
  List<Object?> get props => [id,name,description,price,category,brand,quantity,discount,variant,imageUrl,feature];
}