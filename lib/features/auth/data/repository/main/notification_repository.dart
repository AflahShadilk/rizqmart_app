
import 'package:rizqmart/features/auth/data/data_source/main/notification_data_source.dart';
import 'package:rizqmart/features/auth/data/model/main/notification_model.dart';

abstract class NotificationRepository {
  Stream<List<NotificationModel>> getNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> clearAllNotifications(String userId);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepositoryImpl(this.dataSource);

  @override
  Stream<List<NotificationModel>> getNotifications(String userId) {
    return dataSource.getNotifications(userId);
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    return dataSource.markAsRead(userId, notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    return dataSource.markAllAsRead(userId);
  }

  @override
  Future<void> clearAllNotifications(String userId) async {
    return dataSource.clearAllNotifications(userId);
  }
}
