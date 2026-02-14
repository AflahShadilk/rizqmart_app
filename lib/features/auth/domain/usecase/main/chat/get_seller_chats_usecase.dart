import 'package:rizqmart/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';

class GetSellerChatsUseCase {
  final ChatRepository repository;

  GetSellerChatsUseCase(this.repository);

  Stream<List<ChatEntity>> call(String adminId) {
    return repository.getAdminChats(adminId);
  }
}
