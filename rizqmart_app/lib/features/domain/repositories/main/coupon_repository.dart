import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/coupon_entity.dart';

/// Abstract repository for fetching available promotional coupons.
abstract class CouponRepository {
  Future<Either<Failure, List<CouponEntity>>> getActiveCoupons();
}
