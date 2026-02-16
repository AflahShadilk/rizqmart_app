
import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';

abstract class AddCardState extends Equatable {
  const AddCardState();

  @override
  List<Object> get props => [];
}

class AddCardInitial extends AddCardState {}

class AddCardLoading extends AddCardState {}

class AddCardSuccess extends AddCardState {
  final SavedCardEntity cardEntity;
  const AddCardSuccess(this.cardEntity);

  @override
  List<Object> get props => [cardEntity];
}

class AddCardFailure extends AddCardState {
  final String error;
  const AddCardFailure(this.error);

  @override
  List<Object> get props => [error];
}
