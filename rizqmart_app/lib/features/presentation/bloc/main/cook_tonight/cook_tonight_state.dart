import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/cook_tonight_result_entity.dart';

abstract class CookTonightState extends Equatable {
  const CookTonightState();

  @override
  List<Object?> get props => [];
}

class CookTonightInitial extends CookTonightState {
  const CookTonightInitial();
}

class CookTonightLoading extends CookTonightState {
  const CookTonightLoading();
}

class CookTonightLoaded extends CookTonightState {
  final CookTonightResultEntity result;

  const CookTonightLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class CookTonightError extends CookTonightState {
  final String message;

  const CookTonightError(this.message);

  @override
  List<Object?> get props => [message];
}
