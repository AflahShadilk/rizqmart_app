import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    await emit.forEach(
      getCartItemsUsecase.call(), 
      onData: (result){
        return result.fold(
          (failure) => CartErrorState(message: failure.message),
          (items) {
             if(items.isEmpty){
               return const CartEmptyState();
             }
             return CartLoadedState.fromItems(items);
          },
        );
      },
      onError: (error, stackTrace) {
        return CartErrorState(message: error.toString());
      },
    );
  }

  Future<void>onAddToCart(
    AddToCartEvent event,
    Emitter<CartState>emit
  )async{
    final result = await addToCartUsecase.call(event.productId,event. item);
    result.fold(
      (failure) => emit(CartErrorState(message:'Failed to add to cart: ${failure.message}' )),
      (_) => null, // Success is handled by the stream
    );
  }

  Future<void>onRemoveFromCart(RemoveFromCartEvent event,Emitter<CartState>emit)async{
    final result = await removeFromCartUsecase.call(event.cartItemId);
    result.fold(
      (failure) => emit(CartErrorState(message:'Failed to remove from cart: ${failure.message}' )),
      (_) => null,
    );
  }

  Future <void> onUpdateQuantity(UpdateQuantityEvent event,Emitter<CartState>emit)async{
    final result = await updateCartitemQuantityUsecase.call(event.cartItemId, event.count);
    result.fold(
      (failure) => emit(CartErrorState(message: 'Failed to update: ${failure.message}')),
      (_) => null,
    );
  }

  Future<void>onIncrementQuantity(IncrementQuantityEvent event,Emitter<CartState>emit)async{
    final result = await incrementCartItemUsecase.call(event.cartItemId);
    result.fold(
      (failure) => emit(CartErrorState(message: 'Failed to increment: ${failure.message}')),
      (_) => null,
    );
  }

  Future<void>onDecrementQuantity(DecrementQuantityEvent event,Emitter<CartState>emit)async{
    final result = await decreamentCartItemUsecase.call(event.cartItemId);
    result.fold(
      (failure) => emit(CartErrorState(message: 'Failed to decrement: ${failure.message}')),
      (_) => null,
    );
  }

  Future<void>onClearCart(ClearCartEvent event,Emitter<CartState>emit)async{
    final result = await clearCartItemUsecase.call();
    result.fold(
      (failure) => emit(CartErrorState(message: 'Failed to clear cart: ${failure.message}')),
      (_) => emit(const CartEmptyState()),
    );
  }
}

