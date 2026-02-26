import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/data_source/main/explore_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/explore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/explore_repository.dart';

/// Repository implementation powering the explore tab's product catalog visibility and category filtering.
class ExploreRepositoryImple implements ExploreRepository{
  final ExploreDataSources exploreDataSource;  
  const ExploreRepositoryImple({required this.exploreDataSource});
  
  @override
  Stream<Either<Failure, List<ExploreEntities>>> getAllProducts() {
    return ErrorHandler.executeApiStream(() => exploreDataSource.getAllProducts());
  }

  @override
  Stream<Either<Failure, List<ExploreEntities>>> getProductbyCategory(String category) {
    return ErrorHandler.executeApiStream(() => exploreDataSource.getProductbyCategory(category));
  }

  @override
  Stream<Either<Failure, List<ExploreEntities>>> searchProducts(String query) {
    return ErrorHandler.executeApiStream(() => exploreDataSource.searchProducts(query));
  }

  @override
  Stream<Either<Failure, List<CategoryModel>>> getCategories() {
    return ErrorHandler.executeApiStream(() => exploreDataSource.getCategories());
  }
}