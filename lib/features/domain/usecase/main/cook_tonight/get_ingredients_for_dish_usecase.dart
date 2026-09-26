import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/cook_tonight_result_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/cook_tonight_repository.dart';

class GetIngredientsForDishUsecase {
  final CookTonightRepository _repository;

  GetIngredientsForDishUsecase(this._repository);

  Future<Either<Failure, CookTonightResultEntity>> call({
    required String dishName,
    required int servings,
  }) {
    return _repository.getIngredientsForDish(
      dishName: dishName,
      servings: servings,
    );
  }
}
