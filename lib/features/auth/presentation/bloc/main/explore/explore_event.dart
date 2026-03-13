import 'package:equatable/equatable.dart';
abstract class ExploreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllProductsEvent extends ExploreEvent {
  @override
  List<Object?> get props => [];
}

class GetProductsByCategoryEvent extends ExploreEvent {
  final String category;
  GetProductsByCategoryEvent(this.category);
  
  @override
  List<Object?> get props => [category];
}

class SearchProductsEvent extends ExploreEvent {
  final String query;
  SearchProductsEvent(this.query);
  
  @override
  List<Object?> get props => [query];
}

class GetCategoriesEvent extends ExploreEvent {
  @override
  List<Object?> get props => [];
}