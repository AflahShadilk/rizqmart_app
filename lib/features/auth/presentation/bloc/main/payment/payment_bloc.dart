import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/cancel_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/capture_paypal_payment_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/create_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_cod_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_paypal_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/refund_order_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
 
  final CreateOrderUsecase createOrderUsecase;
  final PayWithPayPalUseCase payWithPayPalUseCase;
  final PayWithCODUseCase payWithCODUseCase;
  final CapturePaypalPaymentUsecase capturePaypalPaymentUsecase;
  final CancelPaymentOrderUseCase cancelOrderUseCase;
  final RefundOrderUseCase refundOrderUseCase;

  OrderEntities? _currentOrder;
  String? _selectedPaymentMethod;
  String? _paypalOrderId;

  PaymentBloc({
    required this.createOrderUsecase,
    required this.payWithPayPalUseCase,
    required this.payWithCODUseCase,
    required this.capturePaypalPaymentUsecase,
    required this.cancelOrderUseCase,
    required this.refundOrderUseCase,
  }) : super(const PaymentInitialState()) {
    on<InitializePaymentEvent>(_onInitializePayment);
    on<ProcessPaymentEvent>(_onProcessPayment);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<CancelPaymentEvent>(_onCancelPayment);
    on<RefundPaymentEvent>(_onRefundPayment);
  }

  Future<void> _onInitializePayment(
    InitializePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(const PaymentLoadingState('Initializing payment...'));

      _currentOrder = event.order;
      _selectedPaymentMethod = event.paymentMethod;

      emit(PaymentMethodSelectedState(
        paymentMethod: event.paymentMethod,
        order: event.order,
      ));
    } catch (e) {
      emit(PaymentFailedState('Failed to initialize payment: $e'));
    }
  }

  Future<void> _onProcessPayment(
    ProcessPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (_currentOrder == null) {
      emit(const PaymentFailedState('Order not initialized'));
      return;
    }

    try {
      emit(const PaymentLoadingState('Creating order...'));

      final createdOrder = await createOrderUsecase.call(_currentOrder!);
      _currentOrder = createdOrder;

      if (_selectedPaymentMethod == 'cod') {
        emit(const PaymentLoadingState('Processing COD payment...'));
        await payWithCODUseCase.call(createdOrder);

        emit(PaymentSuccessState(
          orderId: createdOrder.orderId,
          payment: null,
          order: createdOrder,
        ));
      } else if (_selectedPaymentMethod == 'paypal') {
        emit(const PaymentLoadingState('Preparing PayPal payment...'));

        final payment = await payWithPayPalUseCase.call(createdOrder);
        _paypalOrderId = payment.paymentId;

        emit(PayPalOrderCreatedState(
          paypalOrderId: payment.paymentId,
          approvalLinks: [],
          order: createdOrder,
        ));
      }
    } catch (e) {
      emit(PaymentFailedState('Payment processing failed: $e'));
    }
  }

  Future<void> _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (_currentOrder == null || _paypalOrderId == null) {
      emit(const PaymentFailedState(
        'Order or PayPal transaction not found',
      ));
      return;
    }

    try {
      emit(const PaymentLoadingState('Confirming PayPal payment...'));

      final capturedPayment =
          await capturePaypalPaymentUsecase.call(_paypalOrderId!);

      emit(PaymentSuccessState(
        orderId: _currentOrder!.orderId,
        payment: capturedPayment,
        order: _currentOrder!,
      ));
    } catch (e) {
      emit(PaymentFailedState('Payment confirmation failed: $e'));
    }
  }

  Future<void> _onCancelPayment(
    CancelPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (_currentOrder == null) {
      emit(const PaymentFailedState('Order not found'));
      return;
    }

    try {
      emit(const PaymentLoadingState('Cancelling order...'));

      final cancelledPayment =
          await cancelOrderUseCase.call(_currentOrder!.orderId);

      final orderId = _currentOrder!.orderId;

      _currentOrder = null;
      _selectedPaymentMethod = null;
      _paypalOrderId = null;

      emit(CancellationSuccessState(
        orderId: orderId,
        cancelledPayment: cancelledPayment,
        refundAmount: cancelledPayment.amount,
      ));
    } catch (e) {
      emit(PaymentFailedState('Failed to cancel: $e'));
    }
  }


  Future<void> _onRefundPayment(
    RefundPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(const PaymentLoadingState('Processing refund...'));

      // ignore: unused_local_variable
      final refundedPayment =
          await refundOrderUseCase.call(event.orderId, event.amount);

      emit(RefundSuccessState(
        'Refund of ₹${event.amount.toStringAsFixed(2)} processed successfully',
      ));
    } catch (e) {
      emit(PaymentFailedState('Refund failed: $e'));
    }
  }
}
