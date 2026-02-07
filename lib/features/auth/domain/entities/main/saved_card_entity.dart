import 'package:equatable/equatable.dart';

class SavedCardEntity extends Equatable {
  final String id;
  final String paymentMethodId;
  final String last4;
  final String brand;
  final int expiryMonth;
  final int expiryYear;
  final String cardHolderName;
  final int cardColor; // To display visual card gradient

  const SavedCardEntity({
    required this.id,
    required this.paymentMethodId,
    required this.last4,
    required this.brand,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardHolderName,
    required this.cardColor,
  });

  @override
  List<Object?> get props => [
        id,
        paymentMethodId,
        last4,
        brand,
        expiryMonth,
        expiryYear,
        cardHolderName,
        cardColor,
      ];
}
