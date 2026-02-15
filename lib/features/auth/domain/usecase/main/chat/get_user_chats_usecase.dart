import 'package:rizqmart/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';

class GetUserChatsUseCase {
  final ChatRepository repository;

  GetUserChatsUseCase(this.repository);

  Stream<List<ChatEntity>> call(String userId) {
    return repository.getUserChats(userId);
  }
}
