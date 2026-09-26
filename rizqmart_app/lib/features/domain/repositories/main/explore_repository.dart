import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/model/main/explore_model.dart';
import 'package:rizqmart/features/domain/entities/main/explore_entities.dart';

/// Abstract repository defining operations for searching and browsing the product catalog.
abstract class ExploreRepository {
  Stream<Either<Failure, List<ExploreEntities>>> getAllProducts();
  Stream<Either<Failure, List<ExploreEntities>>> getProductbyCategory(String category);
  Stream<Either<Failure, List<ExploreEntities>>> searchProducts(String query);
  Stream<Either<Failure, List<CategoryModel>>> getCategories();
}