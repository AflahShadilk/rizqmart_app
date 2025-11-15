import 'package:rizqmart/features/auth/data/data_source/main/explore_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/explore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/explore_repository.dart';

class ExploreRepositoryImple implements ExploreRepository{
final ExploreDataSources exploreDataSource;  
const ExploreRepositoryImple({required this.exploreDataSource});
@override
  Stream<List<ExploreEntities>> getAllProducts() {
   return exploreDataSource.getAllProducts();
  }

@override
  Stream<List<ExploreEntities>> getProductbyCategory(String category) {
    
    return exploreDataSource.getProductbyCategory(category);
  }

@override
  Stream<List<ExploreEntities>> searchProducts(String query) {
    return exploreDataSource.searchProducts(query);
  }

@override
  Stream<List<CategoryModel>> getCategories() {
  return exploreDataSource.getCategories();
  }
}