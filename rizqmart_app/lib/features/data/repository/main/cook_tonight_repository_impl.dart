import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/main/cook_tonight_remote_datasource.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/features/domain/entities/main/cook_tonight_result_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/cook_tonight_repository.dart';

class CookTonightRepositoryImpl implements CookTonightRepository {
  final CookTonightRemoteDatasource _datasource;

  CookTonightRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, CookTonightResultEntity>> getIngredientsForDish({
    required String dishName,
    required int servings,
  }) {
    return ErrorHandler.executeApiCall(
      () => _datasource.getIngredientsForDish(
        dishName: dishName,
        servings: servings,
      ),
    );
  }
}
