import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/cook_tonight_result_entity.dart';

abstract class CookTonightRepository {
  Future<Either<Failure, CookTonightResultEntity>> getIngredientsForDish({
    required String dishName,
    required int servings,
  });
}
