import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/message_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/chat_repository.dart';

/// Use case for streaming a real-time list of messages within a specific chat session.
class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Stream<Either<Failure, List<MessageEntity>>> call(String chatId) {
    return repository.getMessages(chatId);
  }
}
