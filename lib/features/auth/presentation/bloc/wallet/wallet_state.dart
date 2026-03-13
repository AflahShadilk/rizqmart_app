import 'package:equatable/equatable.dart';
import '../../../domain/entities/main/wallet_entity.dart';
import '../../../domain/entities/main/wallet_transaction_entity.dart';

enum WalletStatus { initial, loading, loaded, success, error }
class WalletState extends Equatable {
  final WalletStatus status;
  final WalletEntity? wallet;
  final List<WalletTransactionEntity> transactions;
  final String? errorMessage;
  final String? successMessage;

  const WalletState({
    this.status = WalletStatus.initial,
    this.wallet,
    this.transactions = const [],
    this.errorMessage,
    this.successMessage,
  });

  WalletState copyWith({
    WalletStatus? status,
    WalletEntity? wallet,
    List<WalletTransactionEntity>? transactions,
    String? errorMessage,
    String? successMessage,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage, 
      successMessage: successMessage, 
    );
  }

  @override
  List<Object?> get props => [
        status,
        wallet,
        transactions,
        errorMessage,
        successMessage,
      ];
}
