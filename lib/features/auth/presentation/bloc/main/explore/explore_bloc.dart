import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/get_category_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/get_productbycategory_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/get_products_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/search_products_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_state.dart';

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
        final products= await getProductUsecase.call().first;
        final catgories=await getCategoryUsecase.call().first;
        emit(ExploreLoadedState(products:products, categories: catgories));
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
      final products = await getProductbycategoryUsecase.call(event.category).first;
      final categories = await getCategoryUsecase.call().first;
      emit(ExploreLoadedState(
        products: products,
        categories: categories,
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
      final products = await searchProductsUsecase.call(event.query).first;
      final categories = await getCategoryUsecase.call().first;
      emit(ExploreLoadedState(
        products: products,
        categories: categories,
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
