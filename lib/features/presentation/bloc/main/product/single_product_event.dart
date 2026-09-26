part of 'single_product_bloc.dart';

/// Base abstract class defining loading updates for single product data.
abstract class SingleProductEvent extends Equatable {
  const SingleProductEvent();

  @override
  List<Object> get props => [];
}

class GetSingleProductEvent extends SingleProductEvent {
  final String productId;
  const GetSingleProductEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateSingleProductEvent extends SingleProductEvent {
  final ProductEntities product;
  const UpdateSingleProductEvent(this.product);

  @override
  List<Object> get props => [product];
}
