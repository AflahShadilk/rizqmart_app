import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
abstract class CartEvent extends Equatable{
  const CartEvent();
  @override

  List<Object?> get props => [];
}

class GetCartItemsEvent extends CartEvent{
const GetCartItemsEvent();
  @override

  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent{
  final String productId;
  final CartEntities item;
  const AddToCartEvent({required this.productId,required this.item});
    @override

  List<Object?> get props => [productId,item];
}

class RemoveFromCartEvent extends CartEvent {
  final String cartItemId;

  const RemoveFromCartEvent(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class UpdateQuantityEvent extends CartEvent{
  final String cartItemId;
  final int count;
  const UpdateQuantityEvent({required this.cartItemId,required this.count});
  @override
  List<Object?> get props => [cartItemId,count];
}

class IncrementQuantityEvent extends CartEvent{
  final String cartItemId;
  const IncrementQuantityEvent(this.cartItemId);
  @override
  List<Object?> get props => [cartItemId];
}

class DecrementQuantityEvent extends CartEvent{
  final String cartItemId;
  const DecrementQuantityEvent(this.cartItemId);
  @override
  List<Object?> get props => [cartItemId];
}

class ClearCartEvent extends CartEvent{
  const ClearCartEvent();
  @override
  List<Object?> get props => [];
}