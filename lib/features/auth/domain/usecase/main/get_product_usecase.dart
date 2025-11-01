import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/dashboard_repository.dart';

class GetProductUsecase {
  final DashboardRepository repository;
  GetProductUsecase(this.repository);
  Stream<List<ProductEntities>>call(){
    return repository.getAllProducts(); 
  }
}