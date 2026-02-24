import 'package:flutter/material.dart';
import 'package:responsive_display/responsive_display.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/dashboard/search/dash_board_search_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_event.dart';
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
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/auto_scrolling_coupon_list.dart';

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

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<NotificationBloc>().add(LoadNotificationsEvent(user.uid));
    }
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => DashboardSearchCubit(
        searchCubit: ctx.read<SearchCubit>(),
      ),
      child: Builder(
        builder: (context) => ResponsiveWrapper(
        child: Scaffold(
          backgroundColor: context.cs.surface,
          body: Stack(
            children: [
              Column(
                children: [
                  topBarItems(context, searchController, (query) {
                    context.read<DashboardSearchCubit>().search(query);
                  }),
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

                              final searchItems = searchState is SearchReasultState
                                  ? searchState.filteredItems
                                      .whereType<ProductEntities>()
                                      .toList()
                                  : <ProductEntities>[];

                              final displayProducts =
                                  isSearching ? searchItems : products;

                              if (isSearching && displayProducts.isEmpty) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _exclusiveSection(context),
                                        _allProductsSection(context, displayProducts),
                                    ],
                                  ),
                                );
                              }

                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _exclusiveSection(context),
                                      _allProductsSection(context, displayProducts),
                                    ],
                                  ),
                                );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
              _searchDropdown(context),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _exclusiveSection(
    BuildContext context,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppHeading('Exclusive Offers'),
            ],
          ),
        ),
        BlocBuilder<AvailableCouponCubit, AvailableCouponState>(
          builder: (context, state) {
            if (state is AvailableCouponLoading) {
              return const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is AvailableCouponLoaded) {
              if (state.coupons.isEmpty) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: Text('No exclusive offers at the moment.')),
                );
              }
              return AutoScrollingCouponList(coupons: state.coupons);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _allProductsSection(BuildContext context, List<ProductEntities> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppHeading('Products'),
              ReusableSeeAllButton(
                onPress: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.allProduct,
                    arguments: products,
                  );
                },
              ),
            ],
          ),
        ),
        ResponsiveGrid(
          xsmallColumns: 2,
          smallColumns: 2,
          mediumColumns: 3,
          largeColumns: 4,
          xlargeColumns: 4,
          gap: 12,
          childAspectRatio: 0.75,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: List.generate(
            products.length,
            (index) => ProductCard(
              key: ValueKey(products[index].id),
              product: products[index],
            ),
          ),
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
              items: state.filteredItems
                  .whereType<ShowProductEntities>()
                  .toList(),
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