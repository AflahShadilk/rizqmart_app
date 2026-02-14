import 'package:rizqmart/features/auth/domain/repositories/main/chat_repository.dart';

class CreateChatRoomUseCase {
  final ChatRepository repository;

  CreateChatRoomUseCase(this.repository);

  Future<String> call({
    required String orderId,
    required String userId,
    String adminId = 'admin',
    String? productId,
    String? productName,
    String? productImage,
    String? userFcmToken,
  }) async {
    return await repository.createChatRoom(
      orderId: orderId,
      userId: userId,
      adminId: adminId,
      productId: productId,
      productName: productName,
      productImage: productImage,
      userFcmToken: userFcmToken,
    );
  }
}
