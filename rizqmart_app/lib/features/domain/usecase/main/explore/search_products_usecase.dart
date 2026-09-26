import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/explore_repository.dart';

/// Use case for finding products based on a specific textual search query.
class SearchProductsUsecase {
  final ExploreRepository repository;
  const SearchProductsUsecase(this.repository);
  
  Stream<Either<Failure, List<ExploreEntities>>> call(String query) {
    return repository.searchProducts(query);
  }
}