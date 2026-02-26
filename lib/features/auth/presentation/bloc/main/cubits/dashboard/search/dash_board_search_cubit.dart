import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/dashboard/search/dash_board_search_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_cubit.dart';

/// Cubit filtering dashboard products specifically for the search bar interactions.
class DashboardSearchCubit extends Cubit<DashboardSearchState> {
  final SearchCubit searchCubit;

  DashboardSearchCubit({required this.searchCubit}) : super(DashboardSearchIdle());

  void search(String query) {
    searchCubit.search(
      query: query,
      matcher: (item, q) {
        final p = item as ShowProductEntities;
        return p.name.toLowerCase().contains(q.toLowerCase()) ||
            p.brand.toLowerCase().contains(q.toLowerCase());
      },
    );
    emit(DashboardSearchActive(query));
  }

  void clearSearch() {
    searchCubit.clearSearch();
    emit(DashboardSearchIdle());
  }
}