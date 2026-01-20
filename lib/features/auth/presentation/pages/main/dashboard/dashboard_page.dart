// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/empty_product_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/product_card.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/topbar_items.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc helper/circular_progress.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc helper/scaffold_error.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/see_all_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/search_helper_dropdown.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DashBloc>().add(const LoadingProductsEvent());
    context.read<AddressBloc>().add(GetCurrentLocationEvent());
  }

  void _onSearch(String query) {
    context.read<SearchCubit>().search(
          query: query,
          matcher: (item, q) {
            final p = item as ShowProductEntities;
            return p.name.toLowerCase().contains(q) ||
                p.brand.toLowerCase().contains(q);
          },
        );
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
                  buildWhen: (_, current) =>
                      current is DashInitialState ||
                      current is LoadingProductState ||
                      current is LoadedProductState ||
                      current is FailureLoadingProductState,
                  builder: (context, dashState) {
                    if (dashState is DashInitialState ||
                        dashState is LoadingProductState) {
                      return Center(child: circularProgressIndicators());
                    }

                    if (dashState is FailureLoadingProductState) {
                      return errorMessageScaffold(dashState);
                    }

                    if (dashState is LoadedProductState) {
                      final products = dashState.products;
                      context.read<SearchCubit>().setItems(products);

                      return BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, searchState) {
                          final isSearching =
                              searchState is SearchReasultState &&
                                  searchController.text.isNotEmpty;
                          if (isSearching &&
                              searchState.filteredItems.isEmpty) {
                            return buildEmpty(
                              context,
                              isSearching,
                              searchController,
                              () {
                                context.read<SearchCubit>().clearSearch();
                                searchController.clear();
                              },
                            );
                          }
                          if (!isSearching) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _exclusiveSection(context, products),
                                  _allProductsSection(products),
                                ],
                              ),
                            );
                          }
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _exclusiveSection(context, products),
                                _allProductsSection(products),
                              ],
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              )
            ],
          ),
          _searchDropdown(context),
        ],
      ),
    );
  }

  Widget _exclusiveSection(
    BuildContext context,
    List<ProductEntities> displayProducts,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppHeading('Exclusive Offers'),
              ReusableSeeAllButton(
                onPress: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.allProduct,
                    arguments: displayProducts,
                  );
                },
              )
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount:
                displayProducts.length > 10 ? 10 : displayProducts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ProductCard(product: displayProducts[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _allProductsSection(List<ProductEntities> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 25, 16, 12),
          child: AppHeading('All Products'),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (_, index) {
            return ProductCard(
              key: ValueKey(products[index].id),
              product: products[index],
            );
          },
        ),
      ],
    );
  }

  Widget _searchDropdown(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchReasultState &&
            state.filteredItems.isNotEmpty &&
            searchController.text.isNotEmpty) {
          return Positioned(
            top: 195,
            left: 16,
            right: 16,
            child: searchResultsDropdown(
              context: context,
              controller: searchController,
              items: state.filteredItems.cast<ShowProductEntities>(),
              onProductSelected: () {
                context.read<SearchCubit>().clearSearch();
                searchController.clear();
              },
            ),
          );
        }
       
        return const SizedBox();
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}