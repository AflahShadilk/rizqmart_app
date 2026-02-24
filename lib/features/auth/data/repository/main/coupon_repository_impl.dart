import 'package:rizqmart/features/auth/data/data_source/main/coupon_data_source.dart';
import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/coupon_repository.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponDataSource dataSource;

  CouponRepositoryImpl({required this.dataSource});

  @override
  Future<List<CouponEntity>> getActiveCoupons() async {
    return await dataSource.getActiveCoupons();
  }
}
