import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wallet_repository.dart';

/// Use case for deducting funds from a user's digital wallet to pay for an order.
class PayWithWalletUseCase {
  final WalletRepository repository;

  PayWithWalletUseCase(this.repository);

  Future<Either<Failure, WalletTransactionEntity>> call({
    required String userId,
    required double amount,
    required String orderId,
  }) {
    return repository.debitWallet(
      userId: userId,
      amount: amount,
      description: 'Payment for Order #$orderId',
      referenceId: orderId,
      type: TransactionType.purchase,
    );
  }
}
