import 'package:dartz/dartz.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/main/notification_data_source.dart';
import 'package:rizqmart/features/data/model/main/notification_model.dart';

/// Interface for accessing and managing user notification streams and read statuses.
abstract class NotificationRepository {
  Stream<Either<Failure, List<NotificationModel>>> getNotifications(String userId);
  Future<Either<Failure, void>> markAsRead(String userId, String notificationId);
  Future<Either<Failure, void>> markAllAsRead(String userId);
  Future<Either<Failure, void>> clearAllNotifications(String userId);
}

/// Repository implementation integrating notification operations with proper error boundaries.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepositoryImpl(this.dataSource);

  @override
  Stream<Either<Failure, List<NotificationModel>>> getNotifications(String userId) {
    return ErrorHandler.executeApiStream(() => dataSource.getNotifications(userId));
  }

  @override
  Future<Either<Failure, void>> markAsRead(String userId, String notificationId) {
    return ErrorHandler.executeApiCall(() async {
      return await dataSource.markAsRead(userId, notificationId);
    });
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String userId) {
    return ErrorHandler.executeApiCall(() async {
      return await dataSource.markAllAsRead(userId);
    });
  }

  @override
  Future<Either<Failure, void>> clearAllNotifications(String userId) {
    return ErrorHandler.executeApiCall(() async {
      return await dataSource.clearAllNotifications(userId);
    });
  }
}
