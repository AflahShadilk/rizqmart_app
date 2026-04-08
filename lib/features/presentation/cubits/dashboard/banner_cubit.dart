
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  Timer? _timer;
  int _currentPage = 0;
  final int _totalItems;

  BannerCubit({required int totalItems}) 
      : _totalItems = totalItems, 
        super(const BannerInitial(0));

  void startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _totalItems - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      emit(BannerPageUpdated(_currentPage));
    });
  }

  void updatePage(int page) {
    _currentPage = page;
    emit(BannerPageUpdated(_currentPage));
    // Reset timer on manual swipe to avoid immediate auto-scroll
    startAutoScroll();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
