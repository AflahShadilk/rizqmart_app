import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/payment/saved_card_entity.dart';

class SavedCardModel extends SavedCardEntity {
  const SavedCardModel({
    required super.id,
    required super.paymentMethodId,
    required super.last4,
    required super.brand,
    required super.expiryMonth,
    required super.expiryYear,
    required super.cardHolderName,
    required super.cardColor,
  });

  factory SavedCardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SavedCardModel(
      id: doc.id,
      paymentMethodId: data['paymentMethodId'] ?? '',
      last4: data['last4'] ?? '0000',
      brand: data['brand'] ?? 'Unknown',
      expiryMonth: data['expiryMonth'] ?? 0,
      expiryYear: data['expiryYear'] ?? 0,
      cardHolderName: data['cardHolderName'] ?? 'Card Holder',
      cardColor: data['cardColor'] ?? 0xFF000000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentMethodId': paymentMethodId,
      'last4': last4,
      'brand': brand,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cardHolderName': cardHolderName,
      'cardColor': cardColor,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
