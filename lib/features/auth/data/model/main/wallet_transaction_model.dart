import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';


class WalletTransactionModel extends WalletTransactionEntity {
  const WalletTransactionModel({
    required super.id,
    required super.walletId,
    required super.amount,
    required super.type,
    required super.status,
    required super.description,
    required super.timestamp,
    super.referenceId,
  });

  factory WalletTransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return WalletTransactionModel(
      id: id,
      walletId: map['walletId'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      type: _parseType(map['type']),
      status: _parseStatus(map['status']),
      description: map['description'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      referenceId: map['referenceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'amount': amount,
      'type': type.name,
      'status': status.name,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'referenceId': referenceId,
    };
  }

  static TransactionType _parseType(String? type) {
    return TransactionType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => TransactionType.purchase,
    );
  }

  static TransactionStatus _parseStatus(String? status) {
    return TransactionStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TransactionStatus.completed,
    );
  }
}
