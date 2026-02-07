import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';

abstract class DashboardRepository {
  Stream<List<ProductEntities>>getAllProducts();
  Stream<ProductEntities> getProductById(String id);
}