import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
abstract class DashState extends Equatable{
  const DashState();
@override
  List<Object?> get props => [];
}

class DashInitialState extends DashState{
  const DashInitialState();
}

class LoadingProductState extends DashState{
  const LoadingProductState();
}

class LoadedProductState extends DashState{
  final List<ProductEntities>products;
  const LoadedProductState(this.products);
  @override
  List<Object?> get props => [products];
}

class SuccessLoadingProductState extends DashState{
  final String message;
  const SuccessLoadingProductState(this.message);

  @override
  List<Object?> get props => [message];

}

class FailureLoadingProductState extends DashState{
  final String error;
  const FailureLoadingProductState(this.error);
  @override
  List<Object?> get props => [error];

}