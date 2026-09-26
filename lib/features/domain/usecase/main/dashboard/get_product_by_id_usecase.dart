import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/dashboard_repository.dart';

/// Use case for retrieving detailed information about a single product using its unique identifier.
class GetProductByIdUseCase {
  final DashboardRepository repository;

  GetProductByIdUseCase(this.repository);

  Stream<Either<Failure, ProductEntities>> call(String id) {
    return repository.getProductById(id);
  }
}
