import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';
class CouponModel extends CouponEntity {
  const CouponModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.applicableProductIds,
    required super.createdAt,
    required super.expiryDate,
    required super.imageurl,
    required super.isActive,
    required super.minOrderValue,
    required super.percentage,
    required super.usageLimit,
  });

  factory CouponModel.fromMap(Map<String, dynamic> map, String docId) {
    return CouponModel(
      id: docId,
      name: map['name'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      applicableProductIds: List<String>.from(map['applicableProductIds'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiryDate: (map['expiryDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageurl: map['imageurl'] ?? '',
      isActive: map['isActive'] ?? false,
      minOrderValue: (map['minOrderValue'] ?? 0).toDouble(),
      percentage: (map['percentage'] ?? 0).toDouble(),
      usageLimit: map['usageLimit'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'applicableProductIds': applicableProductIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiryDate': Timestamp.fromDate(expiryDate),
      'imageurl': imageurl,
      'isActive': isActive,
      'minOrderValue': minOrderValue,
      'percentage': percentage,
      'usageLimit': usageLimit,
    };
  }
}
