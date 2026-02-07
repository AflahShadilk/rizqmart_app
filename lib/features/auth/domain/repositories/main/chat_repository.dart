import 'package:rizqmart/features/auth/domain/entities/main/message_entity.dart';

abstract class ChatRepository {
  // Initiate or retrieve existing chat for an order
  Future<String> initiateChat({
    required String userId,
    required String sellerId,
    required String orderId,
  });

  // Stream of messages for a specific chat
  Stream<List<MessageEntity>> getMessages(String chatId);

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String type = 'text',
  });
}
