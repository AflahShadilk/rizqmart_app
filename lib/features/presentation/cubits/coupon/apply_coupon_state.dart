import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/coupon_entity.dart';

class ApplyCouponState extends Equatable {
  final CouponEntity? appliedCoupon;
  final double discount;
  final String? error;

  const ApplyCouponState({
    this.appliedCoupon,
    this.discount = 0.0,
    this.error,
  });

  const ApplyCouponState.initial()
      : appliedCoupon = null,
        discount = 0.0,
        error = null;

  bool get hasCoupon => appliedCoupon != null;

  ApplyCouponState copyWith({
    CouponEntity? appliedCoupon,
    double? discount,
    String? error,
    bool clearCoupon = false,
    bool clearError = false,
  }) {
    return ApplyCouponState(
      appliedCoupon: clearCoupon ? null : (appliedCoupon ?? this.appliedCoupon),
      discount: discount ?? this.discount,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [appliedCoupon, discount, error];
}
