import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/main/chat_data_source.dart';
import 'package:rizqmart/features/domain/entities/main/chat_entity.dart';
import 'package:rizqmart/features/domain/entities/main/message_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/chat_repository.dart';

/// Repository implementation routing chat interactions between the UI layer and Firestore data source.
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> createChatRoom({
    required String orderId,
    required String userId,
    String adminId = 'admin',
    String? productId,
    String? productName,
    String? productImage,
    String? userFcmToken,
  }) {
    return ErrorHandler.executeApiCall(() async {
      return await remoteDataSource.createChatRoom(
        orderId: orderId,
        userId: userId,
        adminId: adminId,
        productId: productId,
        productName: productName,
        productImage: productImage,
        userFcmToken: userFcmToken,
      );
    });
  }

  @override
  Stream<Either<Failure, List<ChatEntity>>> getUserChats(String userId) {
    return ErrorHandler.executeApiStream(() => remoteDataSource.getUserChats(userId));
  }

  @override
  Stream<Either<Failure, List<ChatEntity>>> getAdminChats(String adminId) {
    return ErrorHandler.executeApiStream(() => remoteDataSource.getAdminChats(adminId));
  }

  @override
  Stream<Either<Failure, List<MessageEntity>>> getMessages(String chatId) {
    return ErrorHandler.executeApiStream(() => remoteDataSource.getMessages(chatId));
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    required String senderRole,
  }) {
    return ErrorHandler.executeApiCall(() async {
      await remoteDataSource.sendMessage(
        chatId: chatId,
        senderId: senderId,
        text: text,
        senderRole: senderRole,
      );
    });
  }
}
