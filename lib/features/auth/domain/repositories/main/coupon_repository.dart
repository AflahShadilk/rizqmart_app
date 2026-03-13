import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';
abstract class CouponRepository {
  Future<Either<Failure, List<CouponEntity>>> getActiveCoupons();
}
