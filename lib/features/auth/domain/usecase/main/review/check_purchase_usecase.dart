import 'package:rizqmart/features/auth/domain/repositories/main/review_repository.dart';

class CheckPurchaseUseCase {
  final ReviewRepository repository;

  CheckPurchaseUseCase({required this.repository});

  Future<bool> call(String userId, String productId) {
    return repository.hasUserPurchasedProduct(userId, productId);
  }
}
