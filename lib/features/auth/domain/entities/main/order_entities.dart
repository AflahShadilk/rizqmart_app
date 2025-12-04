import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';

class OrderEntities extends Equatable{
  final String orderId;
  final String userId;
  final List<CartEntities> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double totalCost;
  final String deliveryMethod;
  final String paymentMethod;
  final String? promoCode;
  final String status; 
  final DateTime createdAt;
  final String? deliveryAddress;

  const OrderEntities({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalCost,
    required this.deliveryMethod,
    required this.paymentMethod,
    this.promoCode,
    required this.status,
    required this.createdAt,
    this.deliveryAddress,
  });

  @override
  List<Object?> get props => [
        orderId,
        userId,
        items,
        subtotal,
        deliveryFee,
        discount,
        totalCost,
        deliveryMethod,
        paymentMethod,
        promoCode,
        status,
        createdAt,
        deliveryAddress,
      ];
}