import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wallet_repository.dart';
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