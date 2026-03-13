
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/productbycategory/filter_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/productbycategory/filter_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc helper/circular_progress.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'filter_bottom_sheet.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/explore/widgets/filtered_product_grid.dart';
class ProductByCategoryPage extends StatefulWidget {
  final String categoryName;
  const ProductByCategoryPage({super.key, required this.categoryName});

  @override
  State<ProductByCategoryPage> createState() => _ProductByCategoryPageState();
}

class _ProductByCategoryPageState extends State<ProductByCategoryPage> {
late FilterCubit filterCubit;
@override
  void initState() {
    super.initState();
    filterCubit = FilterCubit();
    context.read<ExploreBloc>().add(
          GetProductsByCategoryEvent(widget.categoryName),
        );
  }
@override
  void dispose() {
    filterCubit.close();
    super.dispose();
  }
void showFilters(List<ExploreEntities> allProducts) {
    Set<String> brands = {};
    Set<String> categories = {};
    Set<String> variants = {};

    for (var product in allProducts) {
      if (product.brand.isNotEmpty) brands.add(product.brand);
      if (product.category.isNotEmpty) categories.add(product.category);

      for (var variant in product.variantDetails) {
        String variantName =
            '${variant['unitName'] ?? ''} ${variant['unitType'] ?? ''}'.trim();
        if (variantName.isNotEmpty) variants.add(variantName);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BlocProvider.value(
        value: filterCubit,
        child: FilterBottomSheet(
          brands: brands.toList(),
          categories: categories.toList(),
          variants: variants.toList(),
          selectedBrand: filterCubit.state.selectedBrand,
          selectedCategory: filterCubit.state.selectedCategory,
          selectedVariant: filterCubit.state.selectedVariant,
          onApply: (brand, category, variant) {
            filterCubit.applyFilter(brand, category, variant);
            
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getFilteredVariants(
      List<ExploreEntities> allProducts, FilterState filterState) {
    List<Map<String, dynamic>> allVariants = [];

    for (var product in allProducts) {
      if (product.variantDetails.isEmpty) continue;

      bool matchesBrand = filterState.selectedBrand == null ||
          product.brand == filterState.selectedBrand;
      bool matchesCategory = filterState.selectedCategory == null ||
          product.category == filterState.selectedCategory;

      if (!matchesBrand || !matchesCategory) continue;

      for (int i = 0; i < product.variantDetails.length; i++) {
        Map<String, dynamic> variant = product.variantDetails[i];
        String variantName =
            '${variant['unitName'] ?? ''} ${variant['unitType'] ?? ''}'.trim();

        bool matchesVariant = filterState.selectedVariant == null ||
            variantName == filterState.selectedVariant;

        if (matchesVariant) {
          allVariants.add({
            'product': product,
            'variantIndex': i,
          });
        }
      }
    }

    return allVariants;
  }
@override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return ResponsiveWrapper(child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          widget.categoryName,
          style: GoogleFonts.poppins(
            color: theme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final state = context.read<ExploreBloc>().state;
              if (state is ExploreLoadedState) {
                showFilters(state.products);
              }
            },
            icon: Icon(Symbols.settings, color: theme.primary),
          ),
        ],
      ),
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
          if (state is ExploreLoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomCircularProgressIndicator(),
                  16.h,
                  const Text('Loading products...'),
                ],
              ),
            );
          }

          if (state is ExploreFailureState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 50, color: AppColors.error500),
                  16.h,
                  Text('Error: ${state.message}'),
                  16.h,
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExploreBloc>().add(
                            GetProductsByCategoryEvent(widget.categoryName),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ExploreLoadedState) {
            return BlocBuilder<FilterCubit, FilterState>(
                bloc: filterCubit,
                builder: (context, filterState) {
                  List<Map<String, dynamic>> filteredVariants =
                      getFilteredVariants(state.products, filterState);

                  if (filteredVariants.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined,
                              size: 80, color: AppColors.grey500),
                          16.h,
                          const Text('No products found'),
                        ],
                      ),
                    );
                  }

                  return FilteredProductGrid(filteredVariants: filteredVariants);
                });
          }

          return const Center(child: Text('Loading...'));
        },
      ),
    ));
  }
}