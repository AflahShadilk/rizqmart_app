import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';

abstract class AvailableCouponState extends Equatable {
  const AvailableCouponState();

  @override
  List<Object?> get props => [];
}

class AvailableCouponInitial extends AvailableCouponState {}

class AvailableCouponLoading extends AvailableCouponState {}

class AvailableCouponLoaded extends AvailableCouponState {
  final List<CouponEntity> coupons;

  const AvailableCouponLoaded(this.coupons);

  @override
  List<Object?> get props => [coupons];
}

class AvailableCouponError extends AvailableCouponState {
  final String message;

  const AvailableCouponError(this.message);

  @override
  List<Object?> get props => [message];
}
