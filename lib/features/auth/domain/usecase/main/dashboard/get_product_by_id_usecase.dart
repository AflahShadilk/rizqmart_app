import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/dashboard_repository.dart';

class GetProductByIdUseCase {
  final DashboardRepository repository;

  GetProductByIdUseCase(this.repository);

  Stream<ProductEntities> call(String id) {
    return repository.getProductById(id);
  }
}
