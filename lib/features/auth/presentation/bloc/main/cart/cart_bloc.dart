import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/add_to_cart_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/clear_cart_item_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/decreament_cart_item_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/get_cart_items_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/increment_cart_item_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/remove_from_cart_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/update_cartitem_quantity_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';

class CartBloc extends Bloc<CartEvent,CartState>{
  final GetCartItemsUsecase getCartItemsUsecase;
  final AddToCartUsecase addToCartUsecase;
  final RemoveFromCartUsecase removeFromCartUsecase;
  final UpdateCartitemQuantityUsecase updateCartitemQuantityUsecase;
  final IncrementCartItemUsecase incrementCartItemUsecase;
  final DecreamentCartItemUsecase decreamentCartItemUsecase;
  final ClearCartItemUsecase clearCartItemUsecase;
  StreamSubscription<List<CartEntities>>?cartSubscription;
  CartBloc({
    required this.getCartItemsUsecase,
    required this.addToCartUsecase,
    required this.removeFromCartUsecase,
    required this.updateCartitemQuantityUsecase,
    required this.incrementCartItemUsecase,
    required this.decreamentCartItemUsecase,
    required this.clearCartItemUsecase,
    
  }):super(CartInitialState()){
    on<GetCartItemsEvent>(onGetCartItems);
    on<AddToCartEvent>(onAddToCart);
    on<RemoveFromCartEvent>(onRemoveFromCart);
    on<UpdateQuantityEvent>(onUpdateQuantity);
    on<IncrementQuantityEvent>(onIncrementQuantity);
    on<DecrementQuantityEvent>(onDecrementQuantity);
    on<ClearCartEvent>(onClearCart);

  }
  
  Future<void>onGetCartItems(
    GetCartItemsEvent event,
    Emitter<CartState>emit
  )async{
   emit(const CartLoadingState());
   try{
    await cartSubscription?.cancel();
    await emit.forEach<List<CartEntities>>(
      getCartItemsUsecase.call(), 
      onData: (items){
        if(items.isEmpty){
          return const CartEmptyState();
        }
        return CartLoadedState.fromItems(items);
      },
      onError: (error, stackTrace) {
        return CartErrorState(message: error.toString());
      },);
      
   }catch (e){
    emit(CartErrorState(message: e.toString()));
   }
  }
  Future<void>onAddToCart(
  AddToCartEvent event,
  Emitter<CartState>emit
  )async{
  try{
    await addToCartUsecase.call(event.productId,event. item);

  }catch (e){
    emit(CartErrorState(message:'Failed to add to cart: ${e.toString()}' ));
  }
}

 Future<void>onRemoveFromCart(RemoveFromCartEvent event,Emitter<CartState>emit)async{
  try{
    await removeFromCartUsecase.call(event.cartItemId);
  }catch (e){
    emit(CartErrorState(message:'Failed to remove from cart: ${e.toString()}' ));

  }
 }

 Future <void> onUpdateQuantity(UpdateQuantityEvent event,Emitter<CartState>emit)async{
  try{
    await updateCartitemQuantityUsecase.call(event.cartItemId, event.count);
  }catch (e){
    emit(CartErrorState(message: 'Failed to update: ${e.toString()}'));
  }
 }

 Future<void>onIncrementQuantity(IncrementQuantityEvent event,Emitter<CartState>emit)async{
  try{
    await incrementCartItemUsecase.call(event.cartItemId);
  }catch(e){
   emit(CartErrorState(message: 'Failed to increment: ${e.toString()}'));
  }
 }

 Future<void>onDecrementQuantity(DecrementQuantityEvent event,Emitter<CartState>emit)async{
  try{
    await decreamentCartItemUsecase.call(event.cartItemId);
  }catch(e){
    emit(CartErrorState(message: 'Failed to decrement: ${e.toString()}'));
  }
 }

 Future<void>onClearCart(ClearCartEvent event,Emitter<CartState>emit)async{
  try{
    await clearCartItemUsecase.call();
    emit(const CartEmptyState());
  }catch (e){
    emit(CartErrorState(message: 'Failed to clear cart: ${e.toString()}'));
    
  }

 }
}

