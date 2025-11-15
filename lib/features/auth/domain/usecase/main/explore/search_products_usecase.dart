import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/explore_repository.dart';

class SearchProductsUsecase {
  final ExploreRepository repository;
const  SearchProductsUsecase(this.repository);
Stream<List<ExploreEntities>>call(String query){
    return repository.searchProducts(query);
  }
}