import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import '../../../entities/main/wallet_entity.dart';
import '../../../repositories/main/wallet_repository.dart';

class GetWalletBalanceUseCase {
  final WalletRepository repository;

  GetWalletBalanceUseCase(this.repository);

  Future<Either<Failure, WalletEntity>> call(String userId) {
    return repository.getWalletBalance(userId);
  }
}
