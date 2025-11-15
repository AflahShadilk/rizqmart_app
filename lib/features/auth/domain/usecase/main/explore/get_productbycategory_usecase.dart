import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/explore_repository.dart';

class GetProductbycategoryUsecase{
  final ExploreRepository repository;
const  GetProductbycategoryUsecase(this.repository);
Stream<List<ExploreEntities>>call(String category){
    return repository.getProductbyCategory(category);
  }
}