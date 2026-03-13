import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/chat_entity.dart';
class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.orderId,
    required super.userId,
    required super.adminId,
    super.productId,
    super.productName,
    super.productImage,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.createdAt,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return ChatModel(
    id: doc.id,
    orderId: doc.id,
    userId: data['userId'] ?? '',
    adminId: data['adminId'] ?? 'admin',
    productId: data['productId'],
    productName: data['productName'],
    productImage: data['productImage'],
    lastMessage: data['lastMessage'] ?? '',
    lastMessageTime: data['timestamp'] != null 
        ? (data['timestamp'] as Timestamp).toDate()
        : DateTime.now(),
    createdAt: data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
  );
}

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'adminId': adminId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
