import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/presentation/cubits/dashboard/search/dash_board_search_cubit.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
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
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/search_dropdown_overlay.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/exclusive_offers_section.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/cook_tonight_dashboard_card.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/product_card.dart';

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

  Future<void> _refreshDashboard() async {
    context.read<DashBloc>().add(const LoadingProductsEvent());
    context.read<AddressBloc>().add(GetCurrentLocationEvent());

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<NotificationBloc>().add(LoadNotificationsEvent(user.uid));
    }

    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'See All',
            style: GoogleFonts.manrope(
              color: AppColors.primaryBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(List<ProductEntities> products) {
    if (products.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 280, // Height for ProductCard layout mapping
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: ProductCard(
              key: ValueKey(products[index].id),
              product: products[index],
            ),
          );
        },
      ),
    );
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
            backgroundColor: AppColors.primaryBlue, // Fills the gap securely as header background
            body: Stack(
              children: [
                Column(
                  children: [
                    TopBarItems(
                      searchController: searchController,
                      onSearch: (query) {
                        context.read<DashboardSearchCubit>().search(query);
                      },
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                          child: BlocConsumer<DashBloc, DashState>(
                            listener: (context, state) {
                              if (state is FailureLoadingProductState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)),
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
                                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
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

                                    return RefreshIndicator(
                                      onRefresh: _refreshDashboard,
                                      child: SingleChildScrollView(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(bottom: 24),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const ExclusiveOffersSection(),
                                            const SizedBox(height: 16),
                                            const CookTonightDashboardCard(),
                                            _buildSectionHeader('Popular Products'),
                                            _buildProductRow(displayProducts),
                                            _buildSectionHeader('Categories'),
                                            _buildProductRow(displayProducts.reversed.toList()), // placeholder distribution
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