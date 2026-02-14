import 'package:rizqmart/features/auth/data/data_source/main/chat_data_source.dart';
import 'package:rizqmart/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/message_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> createChatRoom({
    required String orderId,
    required String userId,
    String adminId = 'admin',
    String? productId,
    String? productName,
    String? productImage,
    String? userFcmToken,
  }) async {
    return await remoteDataSource.createChatRoom(
      orderId: orderId,
      userId: userId,
      adminId: adminId,
      productId: productId,
      productName: productName,
      productImage: productImage,
      userFcmToken: userFcmToken,
    );
  }

  @override
  Stream<List<ChatEntity>> getUserChats(String userId) {
    return remoteDataSource.getUserChats(userId);
  }

  @override
  Stream<List<ChatEntity>> getAdminChats(String adminId) {
    return remoteDataSource.getAdminChats(adminId);
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return remoteDataSource.getMessages(chatId);
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    required String senderRole,
  }) async {
    await remoteDataSource.sendMessage(
      chatId: chatId,
      senderId: senderId,
      text: text,
      senderRole: senderRole,
    );
  }
}
