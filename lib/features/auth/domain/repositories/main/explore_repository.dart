import 'package:rizqmart/features/auth/data/model/main/explore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';

abstract class ExploreRepository {
  Stream<List<ExploreEntities>>getAllProducts();
  Stream<List<ExploreEntities>>getProductbyCategory(String category);
  Stream<List<ExploreEntities>>searchProducts(String query);
  Stream<List<CategoryModel>>getCategories();

}