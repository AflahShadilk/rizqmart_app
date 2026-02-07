import 'package:dartz/dartz.dart';
import '../../../entities/main/wallet_entity.dart';
import '../../../repositories/main/wallet_repository.dart';

class GetWalletBalanceUseCase {
  final WalletRepository repository;

  GetWalletBalanceUseCase(this.repository);

  Future<Either<String, WalletEntity>> call(String userId) {
    return repository.getWalletBalance(userId);
  }
}
