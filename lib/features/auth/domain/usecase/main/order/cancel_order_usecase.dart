import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wallet_repository.dart';


class CancelOrderUsecase {
  final OrderRepository repository;
  final WalletRepository walletRepository;

  CancelOrderUsecase(this.repository, this.walletRepository);

  Future<void> call(String orderId) async {
    // 1. Get Order Details
    final order = await repository.getOrderById(orderId);

    // 2. Check if refund is needed
    if (order.paymentMethod.toLowerCase() == 'stripe' || 
        order.paymentMethod.toLowerCase() == 'wallet' ||
        order.paymentMethod.toLowerCase() == 'saved_card') {
      
      // 3. Process Refund to Wallet
      await walletRepository.creditWallet(
        userId: order.userId,
        amount: order.totalCost,
        description: 'Refund for Order #${order.orderId}',
        referenceId: orderId,
        type: TransactionType.refund,
      );
    }

    // 4. Cancel Order
    return await repository.cancelOrder(orderId);
  }
}