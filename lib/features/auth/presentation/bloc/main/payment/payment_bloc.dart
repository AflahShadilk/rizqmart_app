import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/cancel_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/create_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_cod_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_stripe_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/refund_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/pay_with_wallet_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/clear_cart_item_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/core/services/notification_service.dart';
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
  final ClearCartItemUsecase clearCartItemUsecase;

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
    required this.clearCartItemUsecase,
  }) : super(const PaymentInitialState()) {
    on<InitializePaymentEvent>(onInitializePayment);
    on<ProcessPaymentEvent>(onProcessPayment);
    on<CancelPaymentEvent>(onCancelPayment);
    on<RefundPaymentEvent>(onRefundPayment);
  }

  Future<void> _sendSuccessNotification(String orderId, String userId) async {
    try {
      // ---------------- In-App Notification via Firestore ----------------
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add({
        'title': 'Order Placed',
        'body': 'Your order has been placed successfully!',
        'type': 'order',
        'referenceId': orderId,
        'data': {'orderId': orderId},
        'isRead': false,
        'timestamp': Timestamp.now(),
      });

      // ---------------- System Status Bar Notification ----------------
      await NotificationService().showNotification(
        title: 'Order Placed',
        body: 'Your order has been placed successfully!',
        data: {'orderId': orderId, 'type': 'order'},
      );
    } catch (_) {
      // Ignore notification failures
    }
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
          await paymentResult.fold(
            (failure) async {
              await cancelOrderUseCase.call(createdOrder.orderId);
              emit(PaymentFailedState('COD payment failed: ${failure.message}'));
            },
            (_) async {
              await clearCartItemUsecase.call();
              await _sendSuccessNotification(createdOrder.orderId, createdOrder.userId);
              emit(PaymentSuccessState(
                orderId: createdOrder.orderId,
                payment: null,
                order: createdOrder,
              ));
            },
          );
        } else if (selectedPaymentMethod == 'stripe' || selectedPaymentMethod == 'saved_card') { 
          emit(const PaymentLoadingState('Processing Stripe payment...'));
          final paymentResult = await payWithStripeUseCase.call(createdOrder, savedCard: selectedSavedCard); 
          await paymentResult.fold(
            (failure) async {
              await cancelOrderUseCase.call(createdOrder.orderId);
              
              String errorMsg = failure.message;
              if (errorMsg.contains('PaymentMethod was previously used')) {
                errorMsg = 'Payment failed. Please select or add a new card.';
              }
              
              emit(PaymentFailedState('Stripe payment failed: $errorMsg'));
            },
            (payment) async {
              await clearCartItemUsecase.call();
              await _sendSuccessNotification(createdOrder.orderId, createdOrder.userId);
              emit(PaymentSuccessState(
                orderId: createdOrder.orderId,
                payment: payment,
                order: createdOrder,
              ));
            },
          );
        } else if (selectedPaymentMethod == 'wallet') {
          emit(const PaymentLoadingState('Processing Wallet payment...'));
          final result = await payWithWalletUseCase(
            userId: createdOrder.userId,
            amount: createdOrder.totalCost,
            orderId: createdOrder.orderId,
          );
          await result.fold(
            (failure) async {
              await cancelOrderUseCase.call(createdOrder.orderId);
              emit(PaymentFailedState('Wallet payment failed: ${failure.message}'));
            },
            (transaction) async {
              await clearCartItemUsecase.call();
              await _sendSuccessNotification(createdOrder.orderId, createdOrder.userId);
              emit(PaymentSuccessState(
                orderId: createdOrder.orderId,
                payment: null, 
                order: createdOrder,
              ));
            },
          );
        } else {
          await cancelOrderUseCase.call(createdOrder.orderId);
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