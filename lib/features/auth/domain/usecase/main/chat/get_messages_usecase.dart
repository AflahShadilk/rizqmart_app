import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/message_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';
class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Stream<Either<Failure, List<MessageEntity>>> call(String chatId) {
    return repository.getMessages(chatId);
  }
}
