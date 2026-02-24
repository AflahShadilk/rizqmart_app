import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import '../../../entities/main/wallet_transaction_entity.dart';
import '../../../repositories/main/wallet_repository.dart';

class RequestWithdrawalUseCase {
  final WalletRepository repository;

  RequestWithdrawalUseCase(this.repository);

  Future<Either<Failure, WalletTransactionEntity>> call({
    required String userId,
    required double amount,
  }) {
    return repository.requestWithdrawal(userId: userId, amount: amount);
  }
}
