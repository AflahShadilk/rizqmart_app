import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/repositories/main/chat_repository.dart';

/// Use case for initiating a new chat room between a user and an admin, optionally linked to an order or product.
class CreateChatRoomUseCase {
  final ChatRepository repository;

  CreateChatRoomUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String orderId,
    required String userId,
    String adminId = 'admin',
    String? productId,
    String? productName,
    String? productImage,
    String? userFcmToken,
  }) async {
    return repository.createChatRoom(
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
