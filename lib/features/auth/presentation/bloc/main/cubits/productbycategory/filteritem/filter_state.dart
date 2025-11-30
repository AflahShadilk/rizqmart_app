class FiltersState {
  final String? selectedBrand;
  final String? selectedCategory;
  final String? selectedVariant;

  const FiltersState({
    this.selectedBrand,
    this.selectedCategory,
    this.selectedVariant,
  });

  bool get hasActiveFilters =>
      selectedBrand != null || 
      selectedCategory != null || 
      selectedVariant != null;
}