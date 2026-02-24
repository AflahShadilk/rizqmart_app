import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/coupon_repository.dart';

class GetActiveCouponsUseCase {
  final CouponRepository repository;

  GetActiveCouponsUseCase({required this.repository});

  Future<Either<Failure, List<CouponEntity>>> call() async {
    return await repository.getActiveCoupons();
  }
}
