import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/wallet_entity.dart';
import 'package:rizqmart/features/domain/entities/main/wallet_transaction_entity.dart';

/// Abstract repository for tracking digital wallet balances, deposits, and withdrawal transactions.
abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getWalletBalance(String userId);
  Stream<Either<Failure, WalletEntity>> getWalletStream(String userId); 
  
  Future<Either<Failure, WalletTransactionEntity>> creditWallet({
    required String userId,
    required double amount,
    required String description,
    required String referenceId, 
    required TransactionType type,
  });

  Future<Either<Failure, WalletTransactionEntity>> debitWallet({
    required String userId,
    required double amount,
    required String description,
    required String referenceId,
    required TransactionType type,
  });

  Future<Either<Failure, List<WalletTransactionEntity>>> getTransactions(String userId);
  
  Future<Either<Failure, WalletTransactionEntity>> requestWithdrawal({
    required String userId,
    required double amount,
  });
}
