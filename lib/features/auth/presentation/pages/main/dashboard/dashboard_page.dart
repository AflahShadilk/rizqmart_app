// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/empty_product_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/product_card.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/topbar_items.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc helper/circular_progress.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc helper/scaffold_error.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/search_helper.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/search_helper_dropdown.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late SearchHelper<ProductEntities> _searchHelper;
  List<ProductEntities> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _searchHelper = SearchHelper<ProductEntities>(
      allItems: _allProducts,
      matcher: (product, query) {
        return product.name.toLowerCase().contains(query) ||
            product.brand.toLowerCase().contains(query);
      },
    );
  }

  void _onSearch(String query) {
    setState(() {
      _searchHelper.allItems = _allProducts;
      _searchHelper.onSearch(query);
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
              topBarItems(context, _searchHelper.controller, _onSearch),
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

                      if (_searchHelper.isSearching &&
                          _searchHelper.filteredItems.isEmpty) {
                        return buildEmpty(
                          context,
                          _searchHelper.isSearching,
                          _searchHelper.controller,
                          () {
                            _searchHelper.clearSearch();
                            setState(() {});
                          },
                        );
                      }

                      final displayProducts = _searchHelper.isSearching
                          ? _searchHelper.filteredItems
                          : _allProducts;

                      return displayProducts.isEmpty
                          ? buildEmpty(
                              context,
                              _searchHelper.isSearching,
                              _searchHelper.controller,
                              () {
                                _searchHelper.clearSearch();
                                setState(() {});
                              },
                            )
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 20, 16, 12),
                                    child: Text(
                                      'Exclusive Offers',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 210,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      itemCount: displayProducts.length,
                                      itemBuilder: (context, index) {
                                        final product = displayProducts[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: ProductCard(product: product),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 25, 16, 12),
                                    child: Text(
                                      'All Products',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                    ),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
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
          if (_searchHelper.isSearching &&
              _searchHelper.filteredItems.isNotEmpty)
            Positioned(
              top: 120,
              left: 16,
              right: 16,
              child: searchResultsDropdown(context: context, searchHelper: _searchHelper, onProductSelected: ()=>setState(() {
                
              })),
            ),
        ],
      ),
    );
  }

}
