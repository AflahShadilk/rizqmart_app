import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/product_entities.dart';

/// Base abstract class for dashboard-related intent triggers.
abstract class DashEvent extends Equatable{
  const DashEvent();
  @override
  List<Object?> get props => [];
}

class LoadingProductsEvent extends DashEvent{
  const LoadingProductsEvent();
}

class LoadedProductEvent extends DashEvent{
 final List<ProductEntities>products;
 const LoadedProductEvent(this.products);
 @override

  List<Object?> get props => [products];
}

class ErrorLoadingProductEvent extends DashEvent{
  final String message;
  const ErrorLoadingProductEvent(this.message);
  @override
  List<Object?> get props => [message];
}