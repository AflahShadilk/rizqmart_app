import 'package:rizqmart/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/message_entity.dart';

abstract class ChatRepository {
  /// Create or get a chat room for an order (uses orderId as doc ID)
  Future<String> createChatRoom({
    required String orderId,
    required String userId,
    String adminId = 'admin',
    String? productId,
    String? productName,
    String? productImage,
    String? userFcmToken,
  });

  Stream<List<ChatEntity>> getUserChats(String userId);

  Stream<List<ChatEntity>> getAdminChats(String adminId);

  Stream<List<MessageEntity>> getMessages(String chatId);

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    required String senderRole,
  });
}
