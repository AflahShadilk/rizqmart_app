import 'package:equatable/equatable.dart';

/// State retaining validity flags and errors during the wallet top-up flow.
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
