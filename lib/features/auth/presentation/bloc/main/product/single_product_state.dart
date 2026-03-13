part of 'single_product_bloc.dart';
abstract class SingleProductState extends Equatable {
  const SingleProductState();
  
  @override
  List<Object> get props => [];
}

class SingleProductInitial extends SingleProductState {}

class SingleProductLoading extends SingleProductState {}

class SingleProductLoaded extends SingleProductState {
  final ProductEntities product;
  const SingleProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class SingleProductError extends SingleProductState {
  final String message;
  const SingleProductError(this.message);

  @override
  List<Object> get props => [message];
}
