import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/core/services/stripe_services.dart';
import 'package:rizqmart/features/auth/data/data_source/main/cart_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/order_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/payment_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/order_firestore_model.dart';
import 'package:rizqmart/features/auth/data/model/main/payment_firestore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource paymentDataSource;
  final OrderDataSource orderDataSource;
  final CartDataSource cartDataSource;

  PaymentRepositoryImpl({
    required this.paymentDataSource,
    required this.orderDataSource,
    required this.cartDataSource,
  });

  @override
  Future<Either<Failure, OrderEntities>> createOrder(OrderEntities order) {
    return ErrorHandler.executeApiCall(() async {
      final authenticatedUserId = orderDataSource.currentUserId;
      if (authenticatedUserId.isEmpty) throw Exception('User not authenticated');

      final orderId = await orderDataSource.placeOrder(
        OrderFirestoreModel(
          orderId: '',
          userId: authenticatedUserId,
          items: order.items,
          subtotal: order.subtotal,
          deliveryFee: order.deliveryFee,
          discount: order.discount,
          totalCost: order.totalCost,
          deliveryMethod: order.deliveryMethod,
          paymentMethod: order.paymentMethod,
          promoCode: order.promoCode,
          status: 'pending_payment',
          createdAt: DateTime.now(),
          deliveryAddress: order.deliveryAddress,
          userName: order.userName,
          userEmail: order.userEmail,
          userPhone: order.userPhone,
          deliveryNotes: order.deliveryNotes,
        ),
      );

      return OrderFirestoreModel(
        orderId: orderId,
        userId: authenticatedUserId,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        discount: order.discount,
        totalCost: order.totalCost,
        deliveryMethod: order.deliveryMethod,
        paymentMethod: order.paymentMethod,
        promoCode: order.promoCode,
        status: 'pending_payment',
        createdAt: DateTime.now(),
        deliveryAddress: order.deliveryAddress,
        userName: order.userName,
        userEmail: order.userEmail,
        userPhone: order.userPhone,
        deliveryNotes: order.deliveryNotes,
      );
    });
  }

  @override
  Future<Either<Failure, PaymentEntity>> payWithStripe(OrderEntities order, {SavedCardEntity? savedCard}) {
    return ErrorHandler.executeApiCall(() async {
      if (order.orderId.isEmpty) throw Exception('Order ID is required for Stripe payment');

      final authenticatedUserId = orderDataSource.currentUserId;
      if (authenticatedUserId.isEmpty) throw Exception('User not authenticated');

      final paymentIntent = await StripeService.createPaymentIntent(
        amount: order.totalCost,
        currency: 'INR',
        orderId: order.orderId,
      );

      if (!paymentIntent['success']) throw Exception('Failed to create payment intent');

      Map<String, dynamic> confirmation;
      final String paymentIntentId = paymentIntent['paymentIntentId'];

      if (savedCard != null) {
         confirmation = await StripeService.confirmPaymentWithSavedCard(
           clientSecret: paymentIntent['clientSecret'],
           paymentMethodId: savedCard.paymentMethodId,
         );
      } else {
         final success = await StripeService.presentPaymentSheet(
           clientSecret: paymentIntent['clientSecret'],
           merchantDisplayName: 'RizqMart',
         );

         if (!success) throw Exception('Payment cancelled or failed');
         confirmation = await StripeService.confirmPayment(paymentIntentId);
      }

      if (confirmation['success'] != true) throw Exception('Payment verification failed');

      final payment = PaymentFirestoreModel(
        paymentId: paymentIntentId,
        orderId: order.orderId,
        userId: authenticatedUserId,
        amount: order.totalCost,
        method: 'stripe',
        status: 'completed',
        createdAt: DateTime.now(),
      );

      await paymentDataSource.createPayment(payment);

      await orderDataSource.firestore
          .collection('orders')
          .doc(order.orderId)
          .update({
        'status': 'confirmed',
        'paymentId': payment.paymentId,
      });

      return payment;
    });
  }

  @override
  Future<Either<Failure, PaymentEntity>> payWithCOD(OrderEntities order) {
    return ErrorHandler.executeApiCall(() async {
      if (order.orderId.isEmpty) throw Exception('Order ID is required for COD payment');

      final authenticatedUserId = orderDataSource.currentUserId;
      if (authenticatedUserId.isEmpty) throw Exception('User not authenticated');

      final payment = PaymentFirestoreModel(
        paymentId: '',
        orderId: order.orderId,
        userId: authenticatedUserId,
        amount: order.totalCost,
        method: 'cod',
        status: 'pending',
        createdAt: DateTime.now(),
      );

      final paymentId = await paymentDataSource.createPayment(payment);

      await orderDataSource.firestore
          .collection('orders')
          .doc(order.orderId)
          .update({
        'status': 'confirmed',
        'paymentId': paymentId,
      });

      return PaymentFirestoreModel(
        paymentId: paymentId,
        orderId: order.orderId,
        userId: authenticatedUserId,
        amount: order.totalCost,
        method: 'cod',
        status: 'pending',
        createdAt: DateTime.now(),
      );
    });
  }

  @override
  Future<Either<Failure, PaymentEntity>> cancelOrder(String orderId) {
    return ErrorHandler.executeApiCall(() async {
      final payment = await paymentDataSource.getPaymentByOrderId(orderId);
      if (payment == null) throw Exception('Payment not found for order: $orderId');

      await orderDataSource.cancelOrder(orderId);

      if (payment.method == 'stripe' && payment.status == 'completed') {
        final refunded = await StripeService.refundPayment(payment.paymentId);
        if (!refunded) throw Exception('Stripe refund failed');
      }

      await paymentDataSource.updatePaymentStatus(
        payment.paymentId,
        'cancelled',
      );

      return PaymentEntity(
        paymentId: payment.paymentId,
        orderId: orderId,
        userId: payment.userId,
        amount: payment.amount,
        method: payment.method,
        status: 'cancelled',
        createdAt: payment.createdAt,
      );
    });
  }

  @override
  Future<Either<Failure, PaymentEntity>> refundOrder(String orderId, double amount) {
    return ErrorHandler.executeApiCall(() async {
      final payment = await paymentDataSource.getPaymentByOrderId(orderId);
      if (payment == null) throw Exception('Payment not found for order: $orderId');

      if (payment.method == 'stripe') {
        final refunded = await StripeService.refundPayment(
          payment.paymentId,
          amount: amount,
        );
        if (!refunded) throw Exception('Stripe refund failed');
      }

      await paymentDataSource.updatePaymentStatus(
        payment.paymentId,
        'refunded',
      );

      await orderDataSource.firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': 'refunded'});

      return PaymentEntity(
        paymentId: payment.paymentId,
        orderId: orderId,
        userId: payment.userId,
        amount: amount,
        method: payment.method,
        status: 'refunded',
        createdAt: payment.createdAt,
      );
    });
  }
}