/// State detailing the currently applied categorical constraints.
class FilterState {
  final String? selectedBrand;
  final String? selectedCategory;
  final String? selectedVariant;

  const FilterState({this.selectedBrand,this.selectedCategory,this.selectedVariant});

  bool get hasActiveFilters=>selectedBrand!=null||selectedCategory!=null||selectedVariant!=null;
}