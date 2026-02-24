import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/get_category_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/get_productbycategory_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/get_products_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/search_products_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_state.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/data/model/main/explore_model.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetProductsUsecase getProductUsecase;
  final GetProductbycategoryUsecase getProductbycategoryUsecase;
  final SearchProductsUsecase searchProductsUsecase;
  final GetCategoryUsecase getCategoryUsecase;
  ExploreBloc(
      {required this.getProductUsecase,
      required this.getProductbycategoryUsecase,
      required this.searchProductsUsecase,
      required this.getCategoryUsecase})
      : super(ExploreInitialState()) {
        on<GetAllProductsEvent>(onGetProducts);
        on<GetProductsByCategoryEvent>(onGetProductsByCategory);
        on<SearchProductsEvent>(onSearchProducts);
        on<GetCategoriesEvent>(onGetCategories);
      }

      Future<void>onGetProducts(GetAllProductsEvent event,Emitter<ExploreState>emit)async{
           emit(ExploreLoadingState());
        try{
        final results = await Future.wait([
          getProductUsecase.call().first,
          getCategoryUsecase.call().first,
        ]);
        emit(ExploreLoadedState(
          products: results[0] as List<ExploreEntities>,
          categories: results[1] as List<CategoryModel>,
        ));
        }catch(e){
             emit(ExploreFailureState(e.toString()));
        }
      }
       Future<void> onGetProductsByCategory(
    GetProductsByCategoryEvent event,
    Emitter<ExploreState> emit,
  ) async {
    emit(ExploreLoadingState());
    try {
      final results = await Future.wait([
        getProductbycategoryUsecase.call(event.category).first,
        getCategoryUsecase.call().first,
      ]);
      emit(ExploreLoadedState(
        products: results[0] as List<ExploreEntities>,
        categories: results[1] as List<CategoryModel>,
      ));
    } catch (e) {
      emit(ExploreFailureState(e.toString()));
    }
  }

  Future<void> onSearchProducts(
    SearchProductsEvent event,
    Emitter<ExploreState> emit,
  ) async {
    emit(ExploreLoadingState());
    try {
      final results = await Future.wait([
        searchProductsUsecase.call(event.query).first,
        getCategoryUsecase.call().first,
      ]);
      emit(ExploreLoadedState(
        products: results[0] as List<ExploreEntities>,
        categories: results[1] as List<CategoryModel>,
      ));
    } catch (e) {
      emit(ExploreFailureState(e.toString()));
    }
  }

  Future<void> onGetCategories(
    GetCategoriesEvent event,
    Emitter<ExploreState> emit,
  ) async {
    emit(ExploreLoadingState());
    try {
      final categories = await getCategoryUsecase.call().first;
      emit(ExploreLoadedState(
        products: [],
        categories: categories,
      ));
    } catch (e) {
      emit(ExploreFailureState(e.toString()));
    }
  }
}
