import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/review_repository.dart';

class CheckPurchaseUseCase {
  final ReviewRepository repository;

  CheckPurchaseUseCase({required this.repository});

  Future<Either<Failure, bool>> call(String userId, String productId) async {
    return await repository.hasUserPurchasedProduct(userId, productId);
  }
}
