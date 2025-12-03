// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/toggle_see_all/toggle_see_all_button.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/empty_product_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/product_card.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/topbar_items.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc helper/circular_progress.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc helper/scaffold_error.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/see_all_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/search_helper_dropdown.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController searchController = TextEditingController();
  List<ProductEntities> _allProducts = [];
  List<ProductEntities> _cachedDisplayProducts = [];

  void _onSearch(String query) {
    context.read<SearchCubit>().search(
        allItems: _allProducts,
        query: query,
        matcher: (product, q) {
          final p = product as ProductEntities;
          return p.name.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.background,
      body: Stack(
        children: [
          Column(
            children: [
              topBarItems(context, searchController, _onSearch),
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

                      return BlocBuilder<SearchCubit, SearchState>(
                          builder: (context, state) {
                        final isSearching = state is SearchReasultState;
                        final filteredItems =
                            isSearching ? (state).filteredItems : <dynamic>[];
                        final displayProducts = isSearching
                            ? filteredItems.cast<ProductEntities>()
                            : _allProducts;

                        if (displayProducts.isEmpty) {
                          return buildEmpty(
                              context, isSearching, searchController, () {
                            context.read<SearchCubit>().clearSearch();
                            searchController.clear();
                          });
                        }
                        if (displayProducts.length !=
                                _cachedDisplayProducts.length ||
                            _areListsEqual(
                                displayProducts, _cachedDisplayProducts)) {
                          _cachedDisplayProducts = List.from(displayProducts);
                        }
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 20, 16, 12),
                                    child: AppHeading('Exclusive Offers'),
                                  ),
                                  ReusableSeeAllButton(onPress: () {
                                    context
                                        .read<ToggleSeeAllButtonCubit>()
                                        .toggle();
                                  })
                                ],
                              ),
                              BlocBuilder<ToggleSeeAllButtonCubit, bool>(
                                builder: (context, isGrid) {
                                  return isGrid
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          addAutomaticKeepAlives:
                                              true, 
                                          addRepaintBoundaries:
                                              true, 
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.75,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 16,
                                          ),
                                          itemBuilder: (context, index) {
                                            return ProductCard(
                                              key: ValueKey(
                                                  displayProducts[index]
                                                      .id),
                                              product: displayProducts[index],
                                            );
                                          },
                                          itemCount: displayProducts.length,
                                        )
                                      : SizedBox(
                                          height: 210,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            itemCount: displayProducts.length,
                                            itemBuilder: (context, index) {
                                              final product =
                                                  displayProducts[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: ProductCard(
                                                    product: product),
                                              );
                                            },
                                          ),
                                        );
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 25, 16, 12),
                                child: AppHeading('All Products'),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                addAutomaticKeepAlives: true,
                                addRepaintBoundaries: true, 
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 16,
                                ),
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    key: ValueKey(displayProducts[index]
                                        .id), 
                                    product: displayProducts[index],
                                  );
                                },
                                itemCount: displayProducts.length,
                              ),
                            ],
                          ),
                        );
                      });
                    }
                    return const SizedBox();
                  },
                ),
              )
            ],
          ),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchReasultState &&
                  state.filteredItems.isNotEmpty) {
                return Positioned(
                    top: 195,
                    left: 16,
                    right: 16,
                    child: searchResultsDropdown(
                        context: context,
                        controller: searchController,
                        items: state.filteredItems.cast<ProductEntities>(),
                        onProductSelected: () {
                          context.read<SearchCubit>().clearSearch();
                          searchController.clear();
                        }));
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }

  bool _areListsEqual(
      List<ProductEntities> list1, List<ProductEntities> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id) return false;
    }
    return true;
  }
}
