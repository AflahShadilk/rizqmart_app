import 'package:equatable/equatable.dart';

/// Entity storing metadata and context for a chat conversation between user and admin regarding an order.
class ChatEntity extends Equatable {
  final String id; 
  final String orderId;
  final String userId;
  final String adminId;
  final String? productId;
  final String? productName;
  final String? productImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final DateTime createdAt;

  const ChatEntity({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.adminId,
    this.productId,
    this.productName,
    this.productImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        userId,
        adminId,
        productId,
        productName,
        productImage,
        lastMessage,
        lastMessageTime,
        createdAt,
      ];
}
