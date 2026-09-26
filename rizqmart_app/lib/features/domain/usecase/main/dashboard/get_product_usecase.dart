import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/dashboard_repository.dart';

/// Use case for fetching the complete catalogue of products to display on the main dashboard.
class GetProductUsecase {
  final DashboardRepository repository;
  GetProductUsecase(this.repository);
  Stream<Either<Failure, List<ProductEntities>>> call() {
    return repository.getAllProducts(); 
  }
}