import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/productbycategory/filter_state.dart';

/// Cubit organizing constraints like brands, categories, and variants for product filtering.
class FilterCubit extends Cubit<FilterState>{
  FilterCubit():super(const FilterState());
  
  void applyFilter(String? brand,String?category,String? variant){
    emit(FilterState(
      selectedBrand: brand,
      selectedCategory: category,
      selectedVariant: variant
    ));
  }
  void clearFilter(){
    emit(const FilterState());
  }
}