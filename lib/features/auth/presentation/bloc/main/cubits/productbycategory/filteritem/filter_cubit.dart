import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/productbycategory/filteritem/filter_state.dart';

class FiltersCubit extends Cubit<FiltersState> {
  FiltersCubit({
    String? initialBrand,
    String? initialCategory,
    String? initialVariant,
  }) : super(FiltersState(
          selectedBrand: initialBrand,
          selectedCategory: initialCategory,
          selectedVariant: initialVariant,
        ));

  void updateBrand(String? brand) {
    emit(FiltersState(
      selectedBrand: brand,
      selectedCategory: state.selectedCategory,
      selectedVariant: state.selectedVariant,
    ));
  }

  void updateCategory(String? category) {
    emit(FiltersState(
      selectedBrand: state.selectedBrand,
      selectedCategory: category,
      selectedVariant: state.selectedVariant,
    ));
  }

  void updateVariant(String? variant) {
    emit(FiltersState(
      selectedBrand: state.selectedBrand,
      selectedCategory: state.selectedCategory,
      selectedVariant: variant,
    ));
  }

  void clearAll() {
    emit(const FiltersState());
  }
}