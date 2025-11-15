import 'package:rizqmart/features/auth/data/model/main/explore_model.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/explore_repository.dart';

class GetCategoryUsecase {
  final ExploreRepository repository;
const  GetCategoryUsecase(this.repository);
Stream<List<CategoryModel>>call(){
    return repository.getCategories();
  }
}