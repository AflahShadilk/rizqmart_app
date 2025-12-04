// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/productbycategory/filter_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/productbycategory/filter_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/product_details_page/view_details_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc%20helper/circular_progress.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/add_to_cart_button.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/variant_card_reusable.dart';
import 'filter_bottom_sheet.dart';

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
            // Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        title: Text(
          widget.categoryName,
          style: GoogleFonts.poppins(
            color: theme.onBackground,
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
                  circularProgressIndicators(),
                  const SizedBox(height: 16),
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
                  const Icon(Icons.error, size: 50, color:AppColors.error500),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
                          const Text('No products found'),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredVariants.length,
                    itemBuilder: (context, index) {
                      ExploreEntities product =
                          filteredVariants[index]['product'];
                      int variantIndex =
                          filteredVariants[index]['variantIndex'];
                      Map<String, dynamic> variant =
                          product.variantDetails[variantIndex];

                      List<String> imageList =
                          List<String>.from(variant['imageUrls'] ?? []);
                      String image = imageList.isNotEmpty ? imageList[0] : '';
                      String unitName = variant['unitName'] ?? '';

                      double price = (variant['mrp'] ?? 0).toDouble();

                      return VariantCard(
                        productName: product.name,
                        variantName: unitName,
                        price: price,
                        imageUrl: image,
                        colorScheme: context.cs,
                        actionButton: AddToCartButton(
                          widget: product,
                          variantIndex: variantIndex,
                          count: 1,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                product: product,
                                variantIndex: variantIndex,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                });
          }

          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
