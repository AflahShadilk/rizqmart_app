import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/features/auth/data/data_source/main/order_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/order_firestore_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource dataSource;
  final FirebaseAuth auth = FirebaseAuth.instance;

  OrderRepositoryImpl({required this.dataSource});

  @override
  Future<String> placeOrder(OrderEntities order) async {
    final currentUser = auth.currentUser;

    print('📦 Placing Order:');
    print('  - User: ${currentUser?.displayName}');
    print('  - Email: ${currentUser?.email}');
    print('  - Phone: ${order.userPhone}');
    print('  - Address: ${order.deliveryAddress}');
    print('  - Notes: ${order.deliveryNotes}');

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
      userPhone: order.userPhone ?? 'N/A',  // ✅ FIXED: Use order.userPhone
      deliveryNotes: order.deliveryNotes,
    );

    print('✅ Model created with all fields');
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