import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/dashboard/get_product_by_id_usecase.dart';

part 'single_product_event.dart';
part 'single_product_state.dart';

class SingleProductBloc extends Bloc<SingleProductEvent, SingleProductState> {
  final GetProductByIdUseCase getProductByIdUseCase;
  StreamSubscription<ProductEntities>? _productSubscription;

  SingleProductBloc({required this.getProductByIdUseCase})
      : super(SingleProductInitial()) {
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<UpdateSingleProductEvent>(_onUpdateSingleProduct);
  }

  void _onGetSingleProduct(
    GetSingleProductEvent event,
    Emitter<SingleProductState> emit,
  ) {
    emit(SingleProductLoading());
    _productSubscription?.cancel();
    try {
      _productSubscription = getProductByIdUseCase(event.productId).listen(
        (product) => add(UpdateSingleProductEvent(product)),
        onError: (error) => emit(SingleProductError(error.toString())),
      );
    } catch (e) {
      emit(SingleProductError(e.toString()));
    }
  }

  void _onUpdateSingleProduct(
    UpdateSingleProductEvent event,
    Emitter<SingleProductState> emit,
  ) {
    emit(SingleProductLoaded(event.product));
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}
