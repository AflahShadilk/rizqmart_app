import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/auth/data/data_source/main/wallet_remote_datasource.dart';
import 'package:rizqmart/features/auth/data/model/main/wallet_transaction_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wallet_repository.dart';


class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, WalletEntity>> getWalletBalance(String userId) async {
    try {
      final wallet = await remoteDataSource.getWallet(userId);
      return Right(wallet);
    } catch (e) {
      return Left('Failed to get wallet balance: $e');
    }
  }

  @override
  Either<String, Stream<WalletEntity>> getWalletStream(String userId) {
    try {
      return Right(remoteDataSource.getWalletStream(userId));
    } catch (e) {
      return Left('Failed to get wallet stream: $e');
    }
  }

  @override
  Future<Either<String, WalletTransactionEntity>> creditWallet({
    required String userId,
    required double amount,
    required String description,
    required String referenceId,
    required TransactionType type,
  }) async {
    try {
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

      return Right(transaction);
    } catch (e) {
      return Left('Failed to credit wallet: $e');
    }
  }

  @override
  Future<Either<String, WalletTransactionEntity>> debitWallet({
    required String userId,
    required double amount,
    required String description,
    required String referenceId,
    required TransactionType type,
  }) async {
    try {
      final wallet = await remoteDataSource.getWallet(userId);
      
      if (wallet.balance < amount) {
        return const Left('Insufficient wallet balance');
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

      return Right(transaction);
    } catch (e) {
      return Left('Failed to debit wallet: $e');
    }
  }

  @override
  Future<Either<String, List<WalletTransactionEntity>>> getTransactions(String userId) async {
    try {
      final transactions = await remoteDataSource.getTransactions(userId);
      return Right(transactions);
    } catch (e) {
      return Left('Failed to load transactions: $e');
    }
  }

  @override
  Future<Either<String, WalletTransactionEntity>> requestWithdrawal({
    required String userId,
    required double amount,
  }) async {
    try {
       final wallet = await remoteDataSource.getWallet(userId);
      
      if (wallet.balance < amount) {
        return const Left('Insufficient wallet balance');
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

      return Right(transaction);
    } catch (e) {
      return Left('Failed to request withdrawal: $e');
    }
  }
}
