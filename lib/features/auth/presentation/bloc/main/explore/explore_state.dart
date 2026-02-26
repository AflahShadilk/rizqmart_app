import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/data/model/main/explore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';

/// Base abstract class defining the UI states for the explore capability.
abstract class ExploreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExploreInitialState extends ExploreState {
  @override
  List<Object?> get props => [];
}

class ExploreLoadingState extends ExploreState {
  @override
  List<Object?> get props => [];
}

class ExploreLoadedState extends ExploreState {
  final List<ExploreEntities> products;
  final List<CategoryModel> categories;
  
  ExploreLoadedState({
    required this.products,
    required this.categories,
  });
  
  @override
  List<Object?> get props => [products, categories];
}

class ExploreFailureState extends ExploreState {
  final String message;
  
  ExploreFailureState(this.message);
  
  @override
  List<Object?> get props => [message];
}