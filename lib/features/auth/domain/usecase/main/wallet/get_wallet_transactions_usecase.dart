import 'package:dartz/dartz.dart';
import '../../../entities/main/wallet_transaction_entity.dart';
import '../../../repositories/main/wallet_repository.dart';

class GetWalletTransactionsUseCase {
  final WalletRepository repository;

  GetWalletTransactionsUseCase(this.repository);

  Future<Either<String, List<WalletTransactionEntity>>> call(String userId) {
    return repository.getTransactions(userId);
  }
}
