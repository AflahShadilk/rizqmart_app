import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/coupon_repository.dart';

class GetActiveCouponsUseCase {
  final CouponRepository repository;

  GetActiveCouponsUseCase({required this.repository});

  Future<List<CouponEntity>> call() async {
    return await repository.getActiveCoupons();
  }
}
