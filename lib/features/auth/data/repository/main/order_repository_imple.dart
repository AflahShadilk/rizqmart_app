import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/data_source/main/order_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/order_firestore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';

/// Repository implementation managing order creation, retrieval, and status updates through Firestore.
class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource dataSource;
  final FirebaseAuth auth = FirebaseAuth.instance;

  OrderRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, String>> placeOrder(OrderEntities order) {
    return ErrorHandler.executeApiCall(() async {
      final currentUser = auth.currentUser;

      final model = OrderFirestoreModel(
        orderId: order.orderId,
        userId: dataSource.currentUserId,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        discount: order.discount,
        totalCost: order.totalCost,
        deliveryMethod: order.deliveryMethod,
        paymentMethod: order.paymentMethod,
        promoCode: order.promoCode,
        status: 'pending',
        createdAt: DateTime.now(),
        deliveryAddress: order.deliveryAddress ?? '',
        userName: currentUser?.displayName ?? order.userName ?? 'Customer',
        userEmail: currentUser?.email ?? order.userEmail ?? 'no-email@example.com',
        userPhone: order.userPhone ?? 'N/A',  
        deliveryNotes: order.deliveryNotes,
        couponId: order.couponId,
        couponName: order.couponName,
        discountAmount: order.discountAmount,
      );

      return await dataSource.placeOrder(model);
    });
  }

  @override
  Future<Either<Failure, List<OrderEntities>>> getUserOrders() {
    return ErrorHandler.executeApiCall(() async {
      final docs = await dataSource.getUserOrders();
      return docs.map((doc) => OrderFirestoreModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<Either<Failure, OrderEntities>> getOrderById(String orderId) {
    return ErrorHandler.executeApiCall(() async {
      final doc = await dataSource.getOrderById(orderId);
      return OrderFirestoreModel.fromFirestore(doc);
    });
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String orderId) {
    return ErrorHandler.executeApiCall(() async {
      await dataSource.cancelOrder(orderId);
    });
  }
}