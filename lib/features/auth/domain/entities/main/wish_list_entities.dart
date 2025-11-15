import 'package:equatable/equatable.dart';

class WishListEntities extends Equatable{
  final String id;
  final String name;
  final List<Map<String,dynamic>>variantDetails;
  final DateTime? addedAt;
  const WishListEntities({required this.id,required this.name,required this.variantDetails,this.addedAt});
  @override

  List<Object?> get props => [id,name,variantDetails,addedAt];
}