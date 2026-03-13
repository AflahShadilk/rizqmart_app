import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';
class GetUserChatsUseCase {
  final ChatRepository repository;

  GetUserChatsUseCase(this.repository);

  Stream<Either<Failure, List<ChatEntity>>> call(String userId) {
    return repository.getUserChats(userId);
  }
}
