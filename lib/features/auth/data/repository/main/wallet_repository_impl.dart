import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/core/error/exceptions.dart';
import 'package:rizqmart/features/auth/data/data_source/main/wallet_remote_datasource.dart';
import 'package:rizqmart/features/auth/data/model/main/wallet_transaction_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wallet_repository.dart';


/// Repository implementation managing digital wallet balances and logging related transactions across the app.
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, WalletEntity>> getWalletBalance(String userId) {
    return ErrorHandler.executeApiCall(() => remoteDataSource.getWallet(userId));
  }

  @override
  Stream<Either<Failure, WalletEntity>> getWalletStream(String userId) {
    return ErrorHandler.executeApiStream(() => remoteDataSource.getWalletStream(userId));
  }

  @override
  Future<Either<Failure, WalletTransactionEntity>> creditWallet({
    required String userId,
    required double amount,
    required String description,
    required String referenceId,
    required TransactionType type,
  }) {
    return ErrorHandler.executeApiCall(() async {
      final wallet = await remoteDataSource.getWallet(userId);
      final newBalance = wallet.balance + amount;

      final transaction = WalletTransactionModel(
        id: '', 
        walletId: userId,
        amount: amount,
        type: type,
        status: TransactionStatus.completed,
        description: description,
        timestamp: DateTime.now(),
        referenceId: referenceId,
      );

      await remoteDataSource.performWalletTransaction(
        userId: userId,
        newBalance: newBalance,
        transaction: transaction,
      );

      return transaction;
    });
  }

  @override
  Future<Either<Failure, WalletTransactionEntity>> debitWallet({
    required String userId,
    required double amount,
    required String description,
    required String referenceId,
    required TransactionType type,
  }) {
    return ErrorHandler.executeApiCall(() async {
      final wallet = await remoteDataSource.getWallet(userId);
      
      if (wallet.balance < amount) {
        throw const ServerException('Insufficient wallet balance');
      }

      final newBalance = wallet.balance - amount;

      final transaction = WalletTransactionModel(
        id: '',
        walletId: userId,
        amount: amount,
        type: type,
        status: TransactionStatus.completed,
        description: description,
        timestamp: DateTime.now(),
        referenceId: referenceId,
      );

      await remoteDataSource.performWalletTransaction(
        userId: userId,
        newBalance: newBalance,
        transaction: transaction,
      );

      return transaction;
    });
  }

  @override
  Future<Either<Failure, List<WalletTransactionEntity>>> getTransactions(String userId) {
    return ErrorHandler.executeApiCall(() => remoteDataSource.getTransactions(userId));
  }

  @override
  Future<Either<Failure, WalletTransactionEntity>> requestWithdrawal({
    required String userId,
    required double amount,
  }) {
    return ErrorHandler.executeApiCall(() async {
       final wallet = await remoteDataSource.getWallet(userId);
      
      if (wallet.balance < amount) {
        throw const ServerException('Insufficient wallet balance');
      }

      final newBalance = wallet.balance - amount;

      final transaction = WalletTransactionModel(
        id: '',
        walletId: userId,
        amount: amount,
        type: TransactionType.withdrawal,
        status: TransactionStatus.pending, 
        description: 'Withdrawal Request',
        timestamp: DateTime.now(),
      );

      await remoteDataSource.performWalletTransaction(
        userId: userId,
        newBalance: newBalance,
        transaction: transaction,
      );

      return transaction;
    });
  }
}
