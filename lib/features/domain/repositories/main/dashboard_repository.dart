import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/product_entities.dart';

/// Abstract repository for retrieving product data for the main dashboard.
abstract class DashboardRepository {
  Stream<Either<Failure, List<ProductEntities>>> getAllProducts();
  Stream<Either<Failure, ProductEntities>> getProductById(String id);
}