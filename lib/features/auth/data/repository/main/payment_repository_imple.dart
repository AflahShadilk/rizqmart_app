import 'package:rizqmart/core/services/pay_pal_services.dart';
import 'package:rizqmart/features/auth/data/data_source/main/cart_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/order_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/payment_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/order_firestore_model.dart';
import 'package:rizqmart/features/auth/data/model/main/payment_firestore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/payment_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource paymentDataSource;
  final OrderDataSource orderDataSource;
  final CartDataSource cartDataSource;
  final PayPalService payPalService;

  PaymentRepositoryImpl({
    required this.paymentDataSource,
    required this.orderDataSource,
    required this.cartDataSource,
    required this.payPalService,
  });

  @override
  Future<OrderEntities> createOrder(OrderEntities order) async {
    try {
      final orderId = await orderDataSource.placeOrder(
        OrderFirestoreModel(
          orderId: '',
          userId: order.userId,
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
        ),
      );

      return OrderFirestoreModel(
        orderId: orderId,
        userId: order.userId,
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
      );
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<PaymentEntity> payWithPaypal(OrderEntities order) async {
    try {
      if (order.orderId.isEmpty) {
        throw Exception('Order ID is required for PayPal payment');
      }

      final paypalOrderResult = await payPalService.createPayPalOrder(
        amount: order.totalCost,
        orderId: order.orderId,
        description: 'Order from RizqMart - ${order.items.length} items',
        returnUrl: 'https://your-app.com/payment/success',
        cancelUrl: 'https://your-app.com/payment/cancel',
      );

      if (!paypalOrderResult['success']) {
        throw Exception('Failed to create PayPal order');
      }

      final payment = PaymentFirestoreModel(
        paymentId: paypalOrderResult['orderId'],
        orderId: order.orderId,
        userId: order.userId,
        amount: order.totalCost,
        method: 'paypal',
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await paymentDataSource.createPayment(payment);

      return payment;
    } catch (e) {
      throw Exception('PayPal payment failed: $e');
    }
  }

  @override
  Future<PaymentEntity> capturePaypalPayment(String paypalOrderId) async {
    try {
      final captureResult = await payPalService.capturePayment(paypalOrderId);

      if (!captureResult['success']) {
        throw Exception('Failed to capture PayPal payment');
      }

      await paymentDataSource.updatePaymentStatus(
        paypalOrderId,
        'completed',
        transactionId: captureResult['transactionId'],
      );

      final payment =
          await paymentDataSource.getPaymentById(paypalOrderId);

      if (payment != null) {
        await orderDataSource.firestore
            .collection('orders')
            .doc(payment.orderId)
            .update({'status': 'confirmed'});
      }

      final updatedPayment =
          await paymentDataSource.getPaymentById(paypalOrderId);
      return updatedPayment!;
    } catch (e) {
      throw Exception('PayPal payment capture failed: $e');
    }
  }

  @override
  Future<PaymentEntity> payWithCOD(OrderEntities order) async {
    try {
      if (order.orderId.isEmpty) {
        throw Exception('Order ID is required for COD payment');
      }

      final payment = PaymentFirestoreModel(
        paymentId: '',
        orderId: order.orderId,
        userId: order.userId,
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
        userId: order.userId,
        amount: order.totalCost,
        method: 'cod',
        status: 'pending',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('COD payment failed: $e');
    }
  }

  @override
  Future<PaymentEntity> cancelOrder(String orderId) async {
    try {
      final payment = await paymentDataSource.getPaymentByOrderId(orderId);

      if (payment == null) {
        throw Exception('Payment not found for order: $orderId');
      }
      await orderDataSource.cancelOrder(orderId);
      if (payment.method == 'paypal') {
        final refunded = await payPalService.refundPayment(payment.paymentId);
        if (!refunded) {
          throw Exception('PayPal refund failed');
        }
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
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  @override
  Future<PaymentEntity> refundOrder(String orderId, double amount) async {
    try {
      final payment = await paymentDataSource.getPaymentByOrderId(orderId);

      if (payment == null) {
        throw Exception('Payment not found for order: $orderId');
      }

      if (payment.method == 'paypal') {
        final refunded = await payPalService.refundPayment(
          payment.paymentId,
          amount: amount,
        );

        if (!refunded) {
          throw Exception('PayPal refund failed');
        }
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
    } catch (e) {
      throw Exception('Failed to refund order: $e');
    }
  }

  
}
