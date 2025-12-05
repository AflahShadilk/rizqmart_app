import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_state.dart';

class SearchCubit extends Cubit<SearchState>{
  SearchCubit():super(SearchInitialState());
  
  List<dynamic>allItems=[];
  void setItems(List<dynamic>items){
    allItems=items;
  }

  void search({
   
   required String query,
   required bool Function(dynamic item,String query)matcher
  }){
   if (query.trim().isEmpty){
    emit(SearchInitialState());
    return;
   }
  
  final q=query.toLowerCase();
  final filtered=allItems.where((item)=> matcher(item,q)).toList();

  emit(SearchReasultState(filteredItems: filtered, isSearching: true));
  }

  void clearSearch()=>emit(SearchInitialState());
}