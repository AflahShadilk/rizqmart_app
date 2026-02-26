import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/dashboard/get_product_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_state.dart';

/// Business logic for loading and managing products on the main dashboard screen.
class DashBloc extends Bloc<DashEvent, DashState> {
  final GetProductUsecase usecase;
  StreamSubscription<Either<Failure, List<ProductEntities>>>? subscription;

  DashBloc({required this.usecase}) : super(const DashInitialState()) {
    on<LoadingProductsEvent>(loadingProduct);
    on<LoadedProductEvent>(loadedProducts);
    on<ErrorLoadingProductEvent>(errorLoadingProducts);
  }

  Future<void> loadingProduct(
      LoadingProductsEvent event, Emitter<DashState> emit) async {
    emit(LoadingProductState());
    subscription?.cancel();
    subscription = usecase().listen(
      (result) {
        result.fold(
          (failure) => add(ErrorLoadingProductEvent(failure.message)),
          (products) => add(LoadedProductEvent(products)),
        );
      },
      onError: (error) {
        add(ErrorLoadingProductEvent(error.toString()));
      },
    );
  }

  Future<void> loadedProducts(
      LoadedProductEvent event, Emitter<DashState> emit) async {
    emit(LoadedProductState(event.products));
  }

  Future<void> errorLoadingProducts(
      ErrorLoadingProductEvent event, Emitter<DashState> emit) async {
    emit(FailureLoadingProductState(event.message));
  }

 @override
 Future<void> close() {
   subscription?.cancel();
   return super.close();
 }
}