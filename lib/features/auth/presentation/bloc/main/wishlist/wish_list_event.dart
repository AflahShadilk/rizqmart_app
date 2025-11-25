import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';

abstract class WishListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleWishListEvent extends WishListEvent {
  final String productId;
  final String name;
  final String brand;
  final List<Map<String, dynamic>> variantDetails;
  ToggleWishListEvent(this.productId, this.name,this.brand ,this.variantDetails);
  @override
  List<Object?> get props => [productId, name, variantDetails];
}

class GetAllWishListEvent extends WishListEvent{
  @override
  
  List<Object?> get props => [];
}

class AddtoWishListEvent extends WishListEvent{
  final String productId;
  final WishListEntities item;
  AddtoWishListEvent(this.productId,this.item);
   @override
  
  List<Object?> get props => [productId,item];
}

class DeleteWishListEvent extends WishListEvent{
  final String productId;
  DeleteWishListEvent(this.productId);
   @override
  
  List<Object?> get props => [productId];
}