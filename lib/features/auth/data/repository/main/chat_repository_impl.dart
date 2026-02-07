import 'package:rizqmart/features/auth/data/data_source/chat/chat_data_source.dart';
import 'package:rizqmart/features/auth/domain/entities/main/message_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> initiateChat({
    required String userId,
    required String sellerId,
    required String orderId,
  }) async {
    return await remoteDataSource.initiateChat(
      userId: userId,
      sellerId: sellerId,
      orderId: orderId,
    );
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return remoteDataSource.getMessages(chatId);
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String type = 'text',
  }) async {
    await remoteDataSource.sendMessage(
      chatId: chatId,
      senderId: senderId,
      content: content,
      type: type,
    );
  }
}
