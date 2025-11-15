import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/explore_repository.dart';

class GetProductsUsecase {
  final ExploreRepository exploreRepository;
  const GetProductsUsecase(this.exploreRepository);
  Stream<List<ExploreEntities>>call(){
    return exploreRepository.getAllProducts();
  }
  
}