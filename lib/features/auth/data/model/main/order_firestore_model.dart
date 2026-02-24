import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';

class OrderFirestoreModel extends OrderEntities {
  const OrderFirestoreModel({
    required super.orderId,
    required super.userId,
    required super.items,
    required super.subtotal,
    required super.deliveryFee,
    required super.discount,
    required super.totalCost,
    required super.deliveryMethod,
    required super.paymentMethod,
    super.promoCode,
    required super.status,
    required super.createdAt,
    super.deliveryAddress,
    super.userName,
    super.userEmail,
    super.userPhone,
    super.deliveryNotes,
    super.adminNotes,
    super.couponId,
    super.couponName,
    super.discountAmount,
  });

  factory OrderFirestoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderFirestoreModel(
      orderId: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>?)?.map((item) {
        final itemMap = item as Map<String, dynamic>;
        
        return CartEntities(
          id: itemMap['id'] ?? '',
          name: itemMap['name'] ?? '',
          brand: itemMap['brand'] ?? '',
          description: itemMap['description'] ?? '',
          variantDetails: List<Map<String, dynamic>>.from(
              itemMap['variantDetails'] ?? []),
          count: (itemMap['count'] ?? 1).toInt(),
          variantIndex: (itemMap['variantIndex'] ?? 0).toInt(),
          userId: data['userId'] ?? '',
        );
      }).toList() ?? [],
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      totalCost: (data['totalCost'] ?? 0).toDouble(),
      deliveryMethod: data['deliveryMethod'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      promoCode: data['promoCode'],
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deliveryAddress: data['deliveryAddress'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      userEmail: data['userEmail'] ?? 'N/A',
      userPhone: data['userPhone'] ?? 'N/A',
      deliveryNotes: data['deliveryNotes'],
      adminNotes: data['adminNotes'],
      couponId: data['couponId'],
      couponName: data['couponName'],
      discountAmount: (data['discountAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) {
        double priceAtPurchase = 0.0;
        if (item.variantDetails.isNotEmpty &&
            item.variantIndex < item.variantDetails.length) {
          final variant = item.variantDetails[item.variantIndex];
          double price = (variant['mrp'] ?? 0).toDouble();
          final disc = item.discount ?? 0;
          if (disc > 0) price = price - (price * disc / 100);
          priceAtPurchase = price;
        }
        return {
          'id': item.id,
          'name': item.name,
          'brand': item.brand,
          'variantIndex': item.variantIndex,
          'count': item.count,
          'variantDetails': item.variantDetails,
          'priceAtPurchase': priceAtPurchase,
        };
      }).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'totalCost': totalCost,
      'deliveryMethod': deliveryMethod,
      'paymentMethod': paymentMethod,
      'promoCode': promoCode,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'deliveryAddress': deliveryAddress,
      'userName': userName ?? 'Unknown',
      'userEmail': userEmail ?? 'N/A',
      'userPhone': userPhone ?? 'N/A',
      'deliveryNotes': deliveryNotes,
      'adminNotes': adminNotes,
      'couponId': couponId,
      'couponName': couponName,
      'discountAmount': discountAmount ?? 0.0,
    };
  }
}