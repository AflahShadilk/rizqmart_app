import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/main/coupon_data_source.dart';
import 'package:rizqmart/features/domain/entities/main/coupon_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/coupon_repository.dart';

/// Repository implementation fetching active coupons from the data source with error handling.
class CouponRepositoryImpl implements CouponRepository {
  final CouponDataSource dataSource;

  CouponRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<CouponEntity>>> getActiveCoupons() {
    return ErrorHandler.executeApiCall(() async {
      return await dataSource.getActiveCoupons();
    });
  }
}
