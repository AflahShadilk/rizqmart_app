import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/chat_entity.dart';
import 'package:rizqmart/features/domain/repositories/main/chat_repository.dart';

/// Use case for retrieving all active chat sessions assigned to a specific seller or admin.
class GetSellerChatsUseCase {
  final ChatRepository repository;

  GetSellerChatsUseCase(this.repository);

  Stream<Either<Failure, List<ChatEntity>>> call(String adminId) {
    return repository.getAdminChats(adminId);
  }
}
