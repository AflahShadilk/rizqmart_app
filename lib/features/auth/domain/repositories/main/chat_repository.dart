import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/chat_entity.dart';
import 'package:rizqmart/features/auth/domain/entities/main/message_entity.dart';

abstract class ChatRepository {
  
  Future<Either<Failure, String>> createChatRoom({
    required String orderId,
    required String userId,
    String adminId = 'admin',
    String? productId,
    String? productName,
    String? productImage,
    String? userFcmToken,
  });

  Stream<Either<Failure, List<ChatEntity>>> getUserChats(String userId);

  Stream<Either<Failure, List<ChatEntity>>> getAdminChats(String adminId);

  Stream<Either<Failure, List<MessageEntity>>> getMessages(String chatId);

  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    required String senderRole,
  });
}
