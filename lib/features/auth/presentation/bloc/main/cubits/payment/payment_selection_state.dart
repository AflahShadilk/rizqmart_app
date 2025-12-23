class PaymentSelectionState {
  final String selectedPayment;
  final bool isLoading;
  final String? errorMessage;

  const PaymentSelectionState({
    this.selectedPayment = 'cod',
    this.isLoading = false,
    this.errorMessage,
  });

  PaymentSelectionState copyWith({
    String? selectedPayment,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PaymentSelectionState(
      selectedPayment: selectedPayment ?? this.selectedPayment,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentSelectionState &&
          runtimeType == other.runtimeType &&
          selectedPayment == other.selectedPayment &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      selectedPayment.hashCode ^ isLoading.hashCode ^ errorMessage.hashCode;
}