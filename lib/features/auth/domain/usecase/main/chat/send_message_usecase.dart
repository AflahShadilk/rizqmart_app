import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call({
    required String chatId,
    required String senderId,
    required String text,
    required String senderRole,
  }) async {
    await repository.sendMessage(
      chatId: chatId,
      senderId: senderId,
      text: text,
      senderRole: senderRole,
    );
  }
}
