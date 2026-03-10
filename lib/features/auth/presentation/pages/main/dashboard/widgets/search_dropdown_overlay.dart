import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/search_helper_dropdown.dart';

// ---------------- Controllers & Classes ----------------

/// Overlay dropdown widget showing quick search results directly beneath the search bar
class SearchDropdownOverlay extends StatelessWidget {
  final TextEditingController searchController;

  const SearchDropdownOverlay({
    super.key,
    required this.searchController,
  });

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
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
}
