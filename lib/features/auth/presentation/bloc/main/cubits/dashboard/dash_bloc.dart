import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/dashboard/get_product_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/dashboard/dash_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/dashboard/dash_state.dart';

class DashBloc extends Bloc<DashEvent,DashState>{
final GetProductUsecase usecase;
StreamSubscription<List<ProductEntities>>? subscription;
 DashBloc({required this.usecase}):super(LoadingProductState()){
on<LoadingProductsEvent>(loadingProduct);
on<LoadedProductEvent>(loadedProducts);
add(LoadingProductsEvent());
}

 Future<void>loadingProduct(LoadingProductsEvent event,Emitter<DashState>emit)async{
  emit(LoadingProductState());
  subscription?.cancel();
  subscription=usecase().listen((product){
    add(LoadedProductEvent(product));

  },onError: (error){
    emit(FailureLoadingProductState(error));
  });
 }

 Future<void>loadedProducts(LoadedProductEvent event,Emitter<DashState>emit)async{
  emit(LoadedProductState(event.products));
 }
}