import 'package:rizqmart/features/data/model/main/cook_tonight_response_model.dart';

abstract class CookTonightRemoteDatasource {
  Future<CookTonightResponseModel> getIngredientsForDish({
    required String dishName,
    required int servings,
  });
}
