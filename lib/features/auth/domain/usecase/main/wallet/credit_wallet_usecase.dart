import 'package:dartz/dartz.dart';
import '../../../entities/main/wallet_transaction_entity.dart';
import '../../../repositories/main/wallet_repository.dart';

class CreditWalletUseCase {
  final WalletRepository repository;

  CreditWalletUseCase(this.repository);

  Future<Either<String, WalletTransactionEntity>> call({
    required String userId,
    required double amount,
    required String description,
    required String referenceId,
    required TransactionType type,
  }) {
    return repository.creditWallet(
      userId: userId,
      amount: amount,
      description: description,
      referenceId: referenceId,
      type: type,
    );
  }
}
