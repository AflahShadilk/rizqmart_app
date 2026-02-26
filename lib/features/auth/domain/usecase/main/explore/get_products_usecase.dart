import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/explore_repository.dart';

/// Use case for fetching the entire catalogue of products for the explore section.
class GetProductsUsecase {
  final ExploreRepository exploreRepository;
  const GetProductsUsecase(this.exploreRepository);
  
  Stream<Either<Failure, List<ExploreEntities>>> call() {
    return exploreRepository.getAllProducts();
  }
}