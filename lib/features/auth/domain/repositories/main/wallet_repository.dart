import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';


abstract class WalletRepository {
  Future<Either<String, WalletEntity>> getWalletBalance(String userId);
  Either<String, Stream<WalletEntity>> getWalletStream(String userId); 
  
  Future<Either<String, WalletTransactionEntity>> creditWallet({
    required String userId,
    required double amount,
    required String description,
    required String referenceId, 
    required TransactionType type,
  });

  Future<Either<String, WalletTransactionEntity>> debitWallet({
    required String userId,
    required double amount,
    required String description,
    required String referenceId,
    required TransactionType type,
  });

  Future<Either<String, List<WalletTransactionEntity>>> getTransactions(String userId);
  
  Future<Either<String, WalletTransactionEntity>> requestWithdrawal({
    required String userId,
    required double amount,
  });
}
