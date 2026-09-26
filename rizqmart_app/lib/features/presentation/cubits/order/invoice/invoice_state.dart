/// Base abstract class reflecting the status of the invoice generation process.
abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceSuccess extends InvoiceState {}

class InvoiceFailure extends InvoiceState {
  final String message;
  InvoiceFailure(this.message);
}