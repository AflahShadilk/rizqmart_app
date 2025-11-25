import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';

class WishListEntities extends Equatable implements ShowProductEntities{
 @override final String id;
@override  final String name;
@override  final String brand;
@override  final String? description;
@override  final List<Map<String,dynamic>>variantDetails;
  final DateTime? addedAt;
  const WishListEntities({required this.id,required this.name,required this.brand,this.description ,required this.variantDetails,this.addedAt});
  @override

  List<Object?> get props => [id,name,brand,description,variantDetails,addedAt];
}