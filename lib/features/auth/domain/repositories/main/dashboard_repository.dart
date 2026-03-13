import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
abstract class DashboardRepository {
  Stream<Either<Failure, List<ProductEntities>>> getAllProducts();
  Stream<Either<Failure, ProductEntities>> getProductById(String id);
}