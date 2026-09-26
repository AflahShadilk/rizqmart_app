import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/wallet_transaction_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/order_repository.dart';
import 'package:rizqmart/features/domain/repositories/main/wallet_repository.dart';


/// Use case for cancelling an active order and automatically handling necessary wallet refunds.
class CancelOrderUsecase {
  final OrderRepository repository;
  final WalletRepository walletRepository;

  CancelOrderUsecase(this.repository, this.walletRepository);

  Future<Either<Failure, void>> call(String orderId) async {
    final orderResult = await repository.getOrderById(orderId);

    return await orderResult.fold(
      (failure) async => Left(failure),
      (order) async {
        if (order.paymentMethod.toLowerCase() == 'stripe' || 
            order.paymentMethod.toLowerCase() == 'wallet' ||
            order.paymentMethod.toLowerCase() == 'saved_card') {
          
          final creditResult = await walletRepository.creditWallet(
            userId: order.userId,
            amount: order.totalCost,
            description: 'Refund for Order #${order.orderId}',
            referenceId: orderId,
            type: TransactionType.refund,
          );

          return await creditResult.fold(
            (failure) async => Left(failure),
            (_) async => await repository.cancelOrder(orderId),
          );
        }

        return await repository.cancelOrder(orderId);
      },
    );
  }
}