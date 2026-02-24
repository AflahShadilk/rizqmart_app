import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/coupon/get_active_coupons_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_state.dart';

class AvailableCouponCubit extends Cubit<AvailableCouponState> {
  final GetActiveCouponsUseCase getActiveCouponsUseCase;

  AvailableCouponCubit({required this.getActiveCouponsUseCase})
      : super(AvailableCouponInitial());

  Future<void> loadCoupons() async {
    emit(AvailableCouponLoading());
    final result = await getActiveCouponsUseCase();
    result.fold(
      (failure) => emit(AvailableCouponError(failure.message)),
      (coupons) => emit(AvailableCouponLoaded(coupons)),
    );
  }
}
