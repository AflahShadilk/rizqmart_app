import 'package:rizqmart/features/auth/domain/repositories/chat/chat_repository.dart';

class InitiateChatUseCase {
  final ChatRepository repository;

  InitiateChatUseCase(this.repository);

  Future<String> call({
    required String userId,
    required String sellerId,
    required String orderId,
  }) async {
    return await repository.initiateChat(
      userId: userId,
      sellerId: sellerId,
      orderId: orderId,
    );
  }
}
