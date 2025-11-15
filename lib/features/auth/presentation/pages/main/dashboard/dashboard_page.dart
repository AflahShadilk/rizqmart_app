// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/empty_product_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/product_card.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/topbar_items.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/variant_det_getter.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc%20helper/circular_progress.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc%20helper/scaffold_error.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late TextEditingController _searchController;
  List<ProductEntities> _filteredProducts = [];
  List<ProductEntities> _allProducts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredProducts = [];
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.brand.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Column(
            children: [
              topBarItems(context, _searchController, _onSearch),
              Expanded(
  child: BlocBuilder<DashBloc, DashState>(
    buildWhen: (previous, current) =>
        current is LoadingProductState ||
        current is LoadedProductState ||
        current is FailureLoadingProductState,
    builder: (context, state) {
      if (state is LoadingProductState) {
        return Center(child: circularProgressIndicators());
      } else if (state is FailureLoadingProductState) {
        return errorMessageScaffold(state);
      } else if (state is LoadedProductState) {
        _allProducts = state.products;

        if (_isSearching && _filteredProducts.isEmpty) {
          return buildEmpty(
              context, _isSearching, _searchController, () {
            _searchController.clear();
            _onSearch('');
          });
        }

        final displayProducts =
            _isSearching ? _filteredProducts : _allProducts;

        return displayProducts.isEmpty
            ? buildEmpty(
                context, _isSearching, _searchController, () {
                _searchController.clear();
                _onSearch('');
              })
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Text(
                        'Exclusive Offers',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: displayProducts.length,
                        itemBuilder: (context, index) {
                          final product = displayProducts[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ProductCard(product: product),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 25, 16, 12),
                      child: Text(
                        'All Products',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final product = displayProducts[index];
                        return ProductCard(product: product);
                      },
                      itemCount: displayProducts.length,
                    ),
                  ],
                ),
              );
      }
      return const SizedBox();
    },
  ),
)
            ],
          ),
      
          if (_isSearching && _filteredProducts.isNotEmpty)
            Positioned(
              top: 120,
              left: 16,
              right: 16,
              child: searchResultsDropdown(context),
            ),
        ],
      ),
    );
  }

  Widget searchResultsDropdown(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: colorScheme.surface,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount:
              _filteredProducts.length > 5 ? 5 : _filteredProducts.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: colorScheme.onBackground.withOpacity(0.1),
            indent: 12,
            endIndent: 12,
          ),
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            return ListTile(
              onTap: () {
                _searchController.text = product.name;
                _onSearch(product.name);
                FocusScope.of(context).unfocus();
              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.primary.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: getVariantImages(widget).isNotEmpty
                      ? Image.network(
                          getVariantImages(widget).first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported,
                              size: 20,
                              color: colorScheme.primary,
                            );
                          },
                        )
                      : Icon(
                          Icons.image_not_supported,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                ),
              ),
              title: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              subtitle: Text(
                product.brand,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: colorScheme.primary.withOpacity(0.5),
              ),
            );
          },
        ),
      ),
    );
  }
}



