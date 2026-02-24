import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';

abstract class CouponRepository {
  Future<List<CouponEntity>> getActiveCoupons();
}
