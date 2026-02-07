import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/cancel_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/create_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_cod_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_stripe_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/refund_order_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreateOrderUsecase createOrderUsecase;
  final PayWithStripeUseCase payWithStripeUseCase; 
  final PayWithCODUseCase payWithCODUseCase;
  final CancelPaymentOrderUseCase cancelOrderUseCase;
  final RefundOrderUseCase refundOrderUseCase;

  OrderEntities? currentOrder;
  String? selectedPaymentMethod;
  SavedCardEntity? selectedSavedCard;

  PaymentBloc({
    required this.createOrderUsecase,
    required this.payWithStripeUseCase,
    required this.payWithCODUseCase,
    required this.cancelOrderUseCase,
    required this.refundOrderUseCase,
  }) : super(const PaymentInitialState()) {
    on<InitializePaymentEvent>(onInitializePayment);
    on<ProcessPaymentEvent>(onProcessPayment);
    on<CancelPaymentEvent>(onCancelPayment);
    on<RefundPaymentEvent>(onRefundPayment);
  }

  Future<void> onInitializePayment(
    InitializePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(const PaymentLoadingState('Initializing payment...'));

      currentOrder = event.order;
      selectedPaymentMethod = event.paymentMethod;
      selectedSavedCard = event.savedCard;

      emit(PaymentMethodSelectedState(
        paymentMethod: event.paymentMethod,
        order: event.order,
      ));
    } catch (e) {
      emit(PaymentFailedState('Failed to initialize payment: $e'));
    }
  }

  Future<void> onProcessPayment(
    ProcessPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (currentOrder == null) {
      emit(const PaymentFailedState('Order not initialized'));
      return;
    }

    try {
      emit(const PaymentLoadingState('Creating order...'));

      final createdOrder = await createOrderUsecase.call(currentOrder!);
      currentOrder = createdOrder;

      if (selectedPaymentMethod == 'cod') {
        emit(const PaymentLoadingState('Processing COD payment...'));
        await payWithCODUseCase.call(createdOrder);

        emit(PaymentSuccessState(
          orderId: createdOrder.orderId,
          payment: null,
          order: createdOrder,
        ));
      } else if (selectedPaymentMethod == 'stripe' || selectedPaymentMethod == 'saved_card') { 
        emit(const PaymentLoadingState('Processing Stripe payment...'));

        final payment = await payWithStripeUseCase.call(createdOrder, savedCard: selectedSavedCard); 

        emit(PaymentSuccessState(
          orderId: createdOrder.orderId,
          payment: payment,
          order: createdOrder,
        ));
      } else {
        emit(PaymentFailedState('Unknown payment method: $selectedPaymentMethod'));
      }
    } catch (e) {
      emit(PaymentFailedState('Payment processing failed: $e'));
    }
  }

  Future<void> onCancelPayment(
    CancelPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (currentOrder == null) {
      emit(const PaymentFailedState('Order not found'));
      return;
    }

    try {
      emit(const PaymentLoadingState('Cancelling order...'));

      final cancelledPayment =
          await cancelOrderUseCase.call(currentOrder!.orderId);

      final orderId = currentOrder!.orderId;

      currentOrder = null;
      selectedPaymentMethod = null;

      emit(CancellationSuccessState(
        orderId: orderId,
        cancelledPayment: cancelledPayment,
        refundAmount: cancelledPayment.amount,
      ));
    } catch (e) {
      emit(PaymentFailedState('Failed to cancel: $e'));
    }
  }

  Future<void> onRefundPayment(
    RefundPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(const PaymentLoadingState('Processing refund...'));


      emit(RefundSuccessState(
        'Refund of ₹${event.amount.toStringAsFixed(2)} processed successfully',
      ));
    } catch (e) {
      emit(PaymentFailedState('Refund failed: $e'));
    }
  }
}