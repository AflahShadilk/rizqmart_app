import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_entity.dart';


/// Data model representing a user's digital wallet and its current balance in Firestore.
class WalletModel extends WalletEntity {
  const WalletModel({
    required super.userId,
    required super.balance,
    required super.currency,
    required super.lastUpdated,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map, String userId) {
    return WalletModel(
      userId: userId,
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] ?? 'INR',
      lastUpdated: (map['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'currency': currency,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  WalletModel copyWith({
    double? balance,
    DateTime? lastUpdated,
  }) {
    return WalletModel(
      userId: userId,
      balance: balance ?? this.balance,
      currency: currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
