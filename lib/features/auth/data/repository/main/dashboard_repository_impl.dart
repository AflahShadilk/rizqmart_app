import 'package:rizqmart/features/auth/data/data_source/main/dashboard_data_source.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository{
  final DashboardDataSource dataSource;
  DashboardRepositoryImpl({required this.dataSource});
  @override
  Stream<List<ProductEntities>>getAllProducts(){
    return dataSource.getAllProducts();
  }
}