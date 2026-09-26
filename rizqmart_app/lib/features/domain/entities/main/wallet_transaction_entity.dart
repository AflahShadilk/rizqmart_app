import 'package:equatable/equatable.dart';

enum TransactionType { refund, purchase, withdrawal, deposit }
enum TransactionStatus { pending, completed, failed, cancelled }

/// Entity detailing an individual financial transaction occurring within the user's wallet.
class WalletTransactionEntity extends Equatable {
  final String id;
  final String walletId;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final String description;
  final DateTime timestamp;
  final String? referenceId; 

  const WalletTransactionEntity({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    required this.status,
    required this.description,
    required this.timestamp,
    this.referenceId,
  });

  @override
  List<Object?> get props => [
        id,
        walletId,
        amount,
        type,
        status,
        description,
        timestamp,
        referenceId,
      ];
}
