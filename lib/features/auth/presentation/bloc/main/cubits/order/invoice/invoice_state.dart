abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceSuccess extends InvoiceState {}

class InvoiceFailure extends InvoiceState {
  final String message;
  InvoiceFailure(this.message);
}