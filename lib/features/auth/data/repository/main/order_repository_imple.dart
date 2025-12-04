import 'package:rizqmart/features/auth/data/data_source/main/order_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/order_firestore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource dataSource;

  OrderRepositoryImpl({required this.dataSource});

  @override
  Future<String> placeOrder(OrderEntities order) async {
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
      deliveryAddress: order.deliveryAddress,
    );

    return await dataSource.placeOrder(model);
  }

  @override
  Future<List<OrderEntities>> getUserOrders() async {
    final docs = await dataSource.getUserOrders();
    return docs.map((doc) => OrderFirestoreModel.fromFirestore(doc)).toList();
  }

  @override
  Future<OrderEntities> getOrderById(String orderId) async {
    final doc = await dataSource.getOrderById(orderId);
    return OrderFirestoreModel.fromFirestore(doc);
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await dataSource.cancelOrder(orderId);
  }
}
