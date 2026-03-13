import 'package:equatable/equatable.dart';
abstract class SearchState<T> extends Equatable{
  @override
  
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState{}

class SearchReasultState extends SearchState{
  final List<dynamic>filteredItems;
  final bool isSearching;
 SearchReasultState({required this.filteredItems,required this.isSearching});
 @override
  
  List<Object?> get props => [filteredItems,isSearching];
}
