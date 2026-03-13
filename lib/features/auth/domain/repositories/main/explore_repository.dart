import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/model/main/explore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
abstract class ExploreRepository {
  Stream<Either<Failure, List<ExploreEntities>>> getAllProducts();
  Stream<Either<Failure, List<ExploreEntities>>> getProductbyCategory(String category);
  Stream<Either<Failure, List<ExploreEntities>>> searchProducts(String query);
  Stream<Either<Failure, List<CategoryModel>>> getCategories();
}