import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/presentation/cubits/dashboard/search/dash_board_search_cubit.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/presentation/bloc/main/dashboard/dash_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/dashboard/dash_event.dart';
import 'package:rizqmart/features/presentation/bloc/main/dashboard/dash_state.dart';
import 'package:rizqmart/features/presentation/cubits/search_bar/search_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/search_bar/search_state.dart';
import 'package:rizqmart/features/presentation/widgets/search_helper/empty_product_state.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/topbar_items.dart';
import 'package:rizqmart/features/presentation/widgets/bloc%20helper/circular_progress.dart';
import 'package:rizqmart/features/presentation/widgets/bloc%20helper/scaffold_error.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/search_dropdown_overlay.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/exclusive_offers_section.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/all_products_section.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/cook_tonight_dashboard_card.dart';

// ---------------- Controllers & Classes ----------------

/// The primary home screen widget of the app showcasing products, offers, and a search interface.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  // ---------------- Variables ----------------
  final TextEditingController searchController = TextEditingController();

  // ---------------- Init State ----------------
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

  // ---------------- Dashboard Refresh Logic ----------------
  Future<void> _refreshDashboard() async {
    context.read<DashBloc>().add(const LoadingProductsEvent());
    context.read<AddressBloc>().add(GetCurrentLocationEvent());

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<NotificationBloc>().add(LoadNotificationsEvent(user.uid));
    }

    // Delay added to ensure the RefreshIndicator shows the spinner smoothly
    await Future.delayed(const Duration(milliseconds: 1000));
  }



  // ---------------- Dispose ----------------
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    // Provide a localized SearchCubit instance for the Dashboard to manage its search state
    return BlocProvider(
      create: (ctx) => DashboardSearchCubit(
        searchCubit: ctx.read<SearchCubit>(),
      ),
      // Apply responsive layout constraints for different screen sizes
      child: Builder(
        builder: (context) => ResponsiveWrapper(
        child: Scaffold(
          backgroundColor: context.cs.surface,
          // Stack allows the dropdown overlay to appear above the main scrollable content
          body: Stack(
            children: [
              Column(
                children: [
                  // Top bar containing greeting, notifications icons, and the search input field
                  TopBarItems(
                    searchController: searchController,
                    onSearch: (query) {
                      context.read<DashboardSearchCubit>().search(query);
                    },
                  ),
                  // The main view area reacting to the DashBloc state to either load or show products 
                  Expanded(
                    child: BlocConsumer<DashBloc, DashState>(
                      listener: (context, state) {
                        if (state is FailureLoadingProductState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            ErrorMessageSnackBar.build(state),
                          );
                        }
                      },
                      buildWhen: (_, current) =>
                          current is DashInitialState ||
                          current is LoadingProductState ||
                          current is LoadedProductState ||
                          current is FailureLoadingProductState,
                      builder: (context, dashState) {
                        if (dashState is DashInitialState ||
                            dashState is LoadingProductState) {
                          return const Center(child: CustomCircularProgressIndicator());
                        }

                        if (dashState is FailureLoadingProductState) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: 48, color: context.cs.error),
                                const SizedBox(height: 16),
                                Text(dashState.error),
                                TextButton(
                                  onPressed: () {
                                    context.read<DashBloc>().add(const LoadingProductsEvent());
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
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
                                return EmptyProductState(
                                  isSearching: isSearching,
                                  searchText: searchController.text,
                                  onPress: () {
                                    context.read<SearchCubit>().clearSearch();
                                    searchController.clear();
                                  },
                                );
                              }

                              // Main dashboard content
                              return RefreshIndicator(
                                onRefresh: _refreshDashboard,
                                child: SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CookTonightDashboardCard(),
                                      const ExclusiveOffersSection(),
                                      AllProductsSection(products: displayProducts),
                                    ],
                                  ),
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
              SearchDropdownOverlay(searchController: searchController),
            ],
          ),
        ),
      ),
    ),
  );
}
}