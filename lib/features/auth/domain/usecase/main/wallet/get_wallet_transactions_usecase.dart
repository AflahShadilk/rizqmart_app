import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import '../../../entities/main/wallet_transaction_entity.dart';
import '../../../repositories/main/wallet_repository.dart';

class GetWalletTransactionsUseCase {
  final WalletRepository repository;

  GetWalletTransactionsUseCase(this.repository);

  Future<Either<Failure, List<WalletTransactionEntity>>> call(String userId) {
    return repository.getTransactions(userId);
  }
}
