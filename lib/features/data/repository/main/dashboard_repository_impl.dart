import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/main/dashboard_data_source.dart';
import 'package:rizqmart/features/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/dashboard_repository.dart';

/// Repository implementation providing a reliable stream of products for the main dashboard display.
class DashboardRepositoryImpl implements DashboardRepository{
  final DashboardDataSource dataSource;
  DashboardRepositoryImpl({required this.dataSource});
  @override
  Stream<Either<Failure, List<ProductEntities>>> getAllProducts() {
    return ErrorHandler.executeApiStream(() => dataSource.getAllProducts());
  }

  @override
  Stream<Either<Failure, ProductEntities>> getProductById(String id) {
    return ErrorHandler.executeApiStream(() => dataSource.getProductById(id));
  }
}
