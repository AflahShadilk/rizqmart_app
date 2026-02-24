import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/coupon/get_active_coupons_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/coupon/coupon_state.dart';

class AvailableCouponCubit extends Cubit<AvailableCouponState> {
  final GetActiveCouponsUseCase getActiveCouponsUseCase;

  AvailableCouponCubit({required this.getActiveCouponsUseCase})
      : super(AvailableCouponInitial());

  Future<void> loadCoupons() async {
    try {
      emit(AvailableCouponLoading());
      final coupons = await getActiveCouponsUseCase();
      emit(AvailableCouponLoaded(coupons));
    } catch (e) {
      emit(AvailableCouponError(e.toString()));
    }
  }
}
