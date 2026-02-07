import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call({
    required String chatId,
    required String senderId,
    required String content,
    String type = 'text',
  }) async {
    await repository.sendMessage(
      chatId: chatId,
      senderId: senderId,
      content: content,
      type: type,
    );
  }
}
