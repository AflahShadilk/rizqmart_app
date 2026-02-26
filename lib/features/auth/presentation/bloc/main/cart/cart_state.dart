import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';

/// Base abstract class defining the shopping cart's data and UI state.
abstract class CartState extends Equatable{
  const CartState();
  @override
  
  List<Object?> get props => [];
}

class CartInitialState extends CartState{
  const CartInitialState();
}

class CartLoadingState extends CartState{
  const CartLoadingState();
}

class CartLoadedState extends CartState{
  final List<CartEntities>items;
  final double totalAmount;
  final int totalItems;

  const CartLoadedState({required this.items,required this.totalAmount,required this.totalItems});
  @override
  List<Object?> get props => [items,totalAmount,totalItems];

  factory CartLoadedState.fromItems(List<CartEntities>items){
    double total=0.0;
    int itemCount=0;

    for(var item in items){
      if(item.variantDetails.isNotEmpty&&item.variantIndex<item.variantDetails.length){
        final variant = item.variantDetails[item.variantIndex];
        double price = (variant['mrp'] ?? 0).toDouble();
        if (item.discount != null && item.discount! > 0) {
          price = price - (price * item.discount! / 100);
        }
        total += price * item.count;
        itemCount += item.count;
      }
    }
    return CartLoadedState(
        items: items, totalAmount: total, totalItems: itemCount);
  }
  bool get isEmpty=>items.isEmpty;

  int get itemCount=>items.length;
}

class CartEmptyState extends CartState {
  const CartEmptyState();
}

class CartErrorState extends CartState{
  final String message;
  const CartErrorState({required this.message});
  @override
  
  List<Object?> get props => [message];
}

class CartSuccessState extends CartState{
  final String messaage;
  const CartSuccessState({required this.messaage});
  @override
  
  List<Object?> get props => [messaage];
}