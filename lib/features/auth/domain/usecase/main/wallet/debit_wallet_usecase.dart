import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import '../../../entities/main/wallet_transaction_entity.dart';
import '../../../repositories/main/wallet_repository.dart';

class DebitWalletUseCase {
  final WalletRepository repository;

  DebitWalletUseCase(this.repository);

  Future<Either<Failure, WalletTransactionEntity>> call({
    required String userId,
    required double amount,
    required String description,
    required String referenceId,
    required TransactionType type,
  }) {
    return repository.debitWallet(
      userId: userId,
      amount: amount,
      description: description,
      referenceId: referenceId,
      type: type,
    );
  }
}
