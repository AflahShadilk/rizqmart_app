// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc helper/circular_progress.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/search_bar.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/empty_product_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/search_helper_dropdown.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Color> cardColors = [
    Color(0xFFFFF3E0),
    Color(0xFFE8F5E8),
    Color(0xFFE3F2FD),
    Color(0xFFFFEBEE),
    Color(0xFFF3E5F5),
    Color(0xFFFFFDE7),
    Color(0xFFE0F7FA),
    Color(0xFFFCE4EC),
  ];

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

  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(GetCategoriesEvent());
    context.read<ExploreBloc>().add(GetAllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: BlocBuilder<ExploreBloc, ExploreState>(
                    builder: (context, state) {
                      if (state is ExploreLoadingState) {
                        return Center(child: circularProgressIndicators());
                      }

                      if (state is ExploreFailureState) {
                        return Center(
                          child: Column(
                            children: [
                              Text('Error: ${state.message}'),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<ExploreBloc>()
                                      .add(GetCategoriesEvent());
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
                        context.read<SearchCubit>().setItems(state.products);

                        return BlocBuilder<SearchCubit, SearchState>(
                          builder: (context, searchState) {
                            final isSearching =
                                searchState is SearchReasultState;

                            if (isSearching &&
                                searchState.filteredItems.isEmpty) {
                              return buildEmpty(
                                context,
                                true,
                                _searchController,
                                () {
                                  context.read<SearchCubit>().clearSearch();
                                  _searchController.clear();
                                },
                              );
                            }

                            if (!isSearching) {
                              return _categoriesGrid(context, state.categories);
                            }

                            return const SizedBox();
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
          _searchDropdown(context),
        ],
      ),
    );
  }

  Widget _categoriesGrid(BuildContext context, List<dynamic> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final color = cardColors[index % cardColors.length];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.productByCategory,
                arguments: cat.categoryName);
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: context.cs.onSecondary.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ProductImage(
                    imageUrl: cat.logoUrl,
                    height: 60,
                    width: 80,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Text(
                  cat.categoryName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _searchDropdown(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchReasultState && state.filteredItems.isNotEmpty) {
          return Positioned(
            top: 140,
            left: 16,
            right: 16,
            child: searchResultsDropdown(
              context: context,
              controller: _searchController,
              items: state.filteredItems.cast<ShowProductEntities>(),
              onProductSelected: () {
                context.read<SearchCubit>().clearSearch();
                _searchController.clear();
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
