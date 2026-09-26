
import 'package:equatable/equatable.dart';

abstract class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object> get props => [];
}

class BannerInitial extends BannerState {
  final int currentPage;
  const BannerInitial(this.currentPage);

  @override
  List<Object> get props => [currentPage];
}

class BannerPageUpdated extends BannerState {
  final int currentPage;
  const BannerPageUpdated(this.currentPage);

  @override
  List<Object> get props => [currentPage];
}
