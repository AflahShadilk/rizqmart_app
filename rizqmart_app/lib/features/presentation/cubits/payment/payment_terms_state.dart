class PaymentTermsState {
  final bool termsAccepted;

  const PaymentTermsState({this.termsAccepted = false});

  PaymentTermsState copyWith({bool? termsAccepted}) {
    return PaymentTermsState(
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentTermsState &&
          runtimeType == other.runtimeType &&
          termsAccepted == other.termsAccepted;

  @override
  int get hashCode => termsAccepted.hashCode;
}