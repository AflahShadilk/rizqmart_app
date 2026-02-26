import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';

/// Use case for dispatching a text message into a specific chat room.
class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String chatId,
    required String senderId,
    required String text,
    required String senderRole,
  }) async {
    return repository.sendMessage(
      chatId: chatId,
      senderId: senderId,
      text: text,
      senderRole: senderRole,
    );
  }
}
