import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/model/main/explore_model.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/explore_repository.dart';

class GetCategoryUsecase {
  final ExploreRepository repository;
  const GetCategoryUsecase(this.repository);
  
  Stream<Either<Failure, List<CategoryModel>>> call() {
    return repository.getCategories();
  }
}