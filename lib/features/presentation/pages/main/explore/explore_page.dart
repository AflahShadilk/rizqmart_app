

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/explore/explore_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/explore/explore_event.dart';
import 'package:rizqmart/features/presentation/bloc/main/explore/explore_state.dart';
import 'package:rizqmart/features/presentation/cubits/search_bar/search_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/search_bar/search_state.dart';
import 'package:rizqmart/features/presentation/widgets/bloc%20helper/circular_progress.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/presentation/widgets/search_helper/search_bar.dart';
import 'package:rizqmart/features/presentation/widgets/search_helper/empty_product_state.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/presentation/pages/main/explore/widgets/explore_category_grid.dart';
import 'package:rizqmart/features/presentation/pages/main/explore/widgets/explore_search_dropdown.dart';

/// A discoverability page allowing users to search for products and browse available categories.
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  // ---------------- Variables ----------------

  final TextEditingController _searchController = TextEditingController();

  // ---------------- Helper Methods ----------------

  void _onSearch(String query) {
    context.read<SearchCubit>().search(
          query: query,
          matcher: (product, q) {
            return product.name.toLowerCase().contains(q) ||
                product.brand.toLowerCase().contains(q) ||
                ((product.category?.toString().toLowerCase().contains(q) ??
                    false));
          },
        );
  }

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(GetAllProductsEvent());
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(child: Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: AppHeading('Find Product'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SearchField(
                    controller: _searchController,
                    onChanged: _onSearch,
                  ),
                ),
                16.h,
                Expanded(
                  child: BlocListener<ExploreBloc, ExploreState>(
                    listener: (context, state) {
                      if (state is ExploreLoadedState) {
                        context.read<SearchCubit>().setItems(state.products);
                      }
                    },
                    child: BlocBuilder<ExploreBloc, ExploreState>(
                      builder: (context, state) {
                        if (state is ExploreLoadingState) {
                          return const Center(child: CustomCircularProgressIndicator());
                        }

                        if (state is ExploreFailureState) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Error: ${state.message}'),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<ExploreBloc>()
                                        .add(GetAllProductsEvent());
                                  },
                                  icon: const Icon(Icons.refresh),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is ExploreLoadedState) {
                          return BlocBuilder<SearchCubit, SearchState>(
                            builder: (context, searchState) {
                              final isSearching =
                                  searchState is SearchReasultState &&
                                      _searchController.text.isNotEmpty;

                              if (isSearching &&
                                  searchState.filteredItems.isEmpty) {
                                return EmptyProductState(
                                  isSearching: true,
                                  searchText: _searchController.text,
                                  onPress: () {
                                    context.read<SearchCubit>().clearSearch();
                                    _searchController.clear();
                                  },
                                );
                              }
                              return ExploreCategoryGrid(
                                    categories: state.categories);
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ExploreSearchDropdown(searchController: _searchController),
        ],
      ),
    ));
  }

  // ---------------- Dispose ----------------

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}