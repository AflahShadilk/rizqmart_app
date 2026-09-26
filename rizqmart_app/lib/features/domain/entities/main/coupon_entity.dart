import 'package:equatable/equatable.dart';

/// Entity defining a promotional coupon, including its discount percentage, validity, and applicable products.
class CouponEntity extends Equatable {
  final String id;
  final String name;
  final double amount;
  final List<String> applicableProductIds;
  final DateTime createdAt;
  final DateTime expiryDate;
  final String imageurl;
  final bool isActive;
  final double minOrderValue;
  final double percentage;
  final int usageLimit;

  const CouponEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.applicableProductIds,
    required this.createdAt,
    required this.expiryDate,
    required this.imageurl,
    required this.isActive,
    required this.minOrderValue,
    required this.percentage,
    required this.usageLimit,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        applicableProductIds,
        createdAt,
        expiryDate,
        imageurl,
        isActive,
        minOrderValue,
        percentage,
        usageLimit,
      ];
}
