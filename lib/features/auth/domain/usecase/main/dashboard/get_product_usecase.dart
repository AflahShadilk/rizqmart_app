import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/dashboard_repository.dart';
class GetProductUsecase {
  final DashboardRepository repository;
  GetProductUsecase(this.repository);
  Stream<Either<Failure, List<ProductEntities>>> call() {
    return repository.getAllProducts(); 
  }
}