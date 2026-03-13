import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
class OrderEntities extends Equatable {
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
  final String? paymentStatus;
  final DateTime createdAt;
  final String? deliveryAddress;
  final String? userName;
  final String? userEmail;
  final String? userPhone;

  final String? deliveryNotes;
  final String? adminNotes;
  final String? couponId;
  final String? couponName;
  final double? discountAmount;

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
    this.paymentStatus,
    required this.createdAt,
    this.deliveryAddress,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.deliveryNotes,
    this.adminNotes,
    this.couponId,
    this.couponName,
    this.discountAmount,
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
        paymentStatus,
        createdAt,
        deliveryAddress,
        userName,
        userEmail,
        userPhone,

        deliveryNotes,
        adminNotes,
        couponId,
        couponName,
        discountAmount,
      ];

  OrderEntities copyWith({
    String? orderId,
    String? userId,
    List<CartEntities>? items,
    double? subtotal,
    double? deliveryFee,
    double? discount,
    double? totalCost,
    String? deliveryMethod,
    String? paymentMethod,
    String? promoCode,
    String? status,
    String? paymentStatus,
    DateTime? createdAt,
    String? deliveryAddress,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? deliveryNotes,
    String? adminNotes,
    String? couponId,
    String? couponName,
    double? discountAmount,
  }) {
    return OrderEntities(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      totalCost: totalCost ?? this.totalCost,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      adminNotes: adminNotes ?? this.adminNotes,
      couponId: couponId ?? this.couponId,
      couponName: couponName ?? this.couponName,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}
