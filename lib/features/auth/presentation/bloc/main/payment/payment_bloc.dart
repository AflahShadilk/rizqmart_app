import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/cancel_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/create_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_cod_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_stripe_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/refund_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_wallet_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_state.dart';

/// Business logic orchestrating various payment gateways (Stripe, COD, Wallet) and order processing.
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreateOrderUsecase createOrderUsecase;
  final PayWithStripeUseCase payWithStripeUseCase;
  final PayWithCODUseCase payWithCODUseCase;
  final CancelPaymentOrderUseCase cancelOrderUseCase;
  final RefundOrderUseCase refundOrderUseCase;
  final PayWithWalletUseCase payWithWalletUseCase;

  OrderEntities? currentOrder;
  String? selectedPaymentMethod;
  SavedCardEntity? selectedSavedCard;

  PaymentBloc({
    required this.createOrderUsecase,
    required this.payWithStripeUseCase,
    required this.payWithCODUseCase,
    required this.cancelOrderUseCase,
    required this.refundOrderUseCase,
    required this.payWithWalletUseCase, 
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
    emit(const PaymentLoadingState('Initializing payment...'));

    currentOrder = event.order;
    selectedPaymentMethod = event.paymentMethod;
    selectedSavedCard = event.savedCard;

    emit(PaymentMethodSelectedState(
      paymentMethod: event.paymentMethod,
      order: event.order,
    ));
  }

  Future<void> onProcessPayment(
    ProcessPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (currentOrder == null) {
      emit(const PaymentFailedState('Order not initialized'));
      return;
    }

    emit(const PaymentLoadingState('Creating order...'));

    final createdOrderResult = await createOrderUsecase.call(currentOrder!);
    
    await createdOrderResult.fold(
      (failure) async => emit(PaymentFailedState('Failed to create order: ${failure.message}')),
      (createdOrder) async {
        currentOrder = createdOrder;

        if (selectedPaymentMethod == 'cod') {
          emit(const PaymentLoadingState('Processing COD payment...'));
          final paymentResult = await payWithCODUseCase.call(createdOrder);
          paymentResult.fold(
            (failure) => emit(PaymentFailedState('COD payment failed: ${failure.message}')),
            (_) => emit(PaymentSuccessState(
              orderId: createdOrder.orderId,
              payment: null,
              order: createdOrder,
            )),
          );
        } else if (selectedPaymentMethod == 'stripe' || selectedPaymentMethod == 'saved_card') { 
          emit(const PaymentLoadingState('Processing Stripe payment...'));
          final paymentResult = await payWithStripeUseCase.call(createdOrder, savedCard: selectedSavedCard); 
          paymentResult.fold(
            (failure) => emit(PaymentFailedState('Stripe payment failed: ${failure.message}')),
            (payment) => emit(PaymentSuccessState(
              orderId: createdOrder.orderId,
              payment: payment,
              order: createdOrder,
            )),
          );
        } else if (selectedPaymentMethod == 'wallet') {
          emit(const PaymentLoadingState('Processing Wallet payment...'));
          final result = await payWithWalletUseCase(
            userId: createdOrder.userId,
            amount: createdOrder.totalCost,
            orderId: createdOrder.orderId,
          );
          result.fold(
            (failure) => emit(PaymentFailedState('Wallet payment failed: ${failure.message}')),
            (transaction) => emit(PaymentSuccessState(
              orderId: createdOrder.orderId,
              payment: null, 
              order: createdOrder,
            )),
          );
        } else {
          emit(PaymentFailedState('Unknown payment method: $selectedPaymentMethod'));
        }
      },
    );
  }

  Future<void> onCancelPayment(
    CancelPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (currentOrder == null) {
      emit(const PaymentFailedState('Order not found'));
      return;
    }

    emit(const PaymentLoadingState('Cancelling order...'));

    final result = await cancelOrderUseCase.call(currentOrder!.orderId);
    
    result.fold(
      (failure) => emit(PaymentFailedState('Failed to cancel: ${failure.message}')),
      (cancelledPayment) {
        final orderId = currentOrder!.orderId;
        currentOrder = null;
        selectedPaymentMethod = null;

        emit(CancellationSuccessState(
          orderId: orderId,
          cancelledPayment: cancelledPayment,
          refundAmount: cancelledPayment.amount,
        ));
      },
    );
  }

  Future<void> onRefundPayment(
    RefundPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoadingState('Processing refund...'));
    // The previous implementation was a placeholder. 
    // Usually, we would call refundOrderUseCase.
    final result = await refundOrderUseCase.call(event.orderId, event.amount);
    
    result.fold(
      (failure) => emit(PaymentFailedState('Refund failed: ${failure.message}')),
      (_) => emit(RefundSuccessState(
        'Refund of ₹${event.amount.toStringAsFixed(2)} processed successfully',
      )),
    );
  }
}