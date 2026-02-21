import 'package:equatable/equatable.dart';

class AddMoneyState extends Equatable {
  final bool isValid;
  final String? errorMessage;

  const AddMoneyState({
    this.isValid = false,
    this.errorMessage,
  });

  const AddMoneyState.initial()
      : isValid = false,
        errorMessage = null;

  AddMoneyState copyWith({
    bool? isValid,
    String? errorMessage,
  }) {
    return AddMoneyState(
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isValid, errorMessage];
}
