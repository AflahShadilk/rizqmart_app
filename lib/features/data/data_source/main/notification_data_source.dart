
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/data/model/main/notification_model.dart';

/// Interface outlining operations for retrieving and managing user notifications.
abstract class NotificationDataSource {
  Stream<List<NotificationModel>> getNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> clearAllNotifications(String userId);
}

/// Firestore implementation for real-time notification streaming and state management.
class NotificationDataSourceImpl implements NotificationDataSource {
  final FirebaseFirestore firestore;

  NotificationDataSourceImpl(this.firestore);

  @override
  Stream<List<NotificationModel>> getNotifications(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final batch = firestore.batch();
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  @override
  Future<void> clearAllNotifications(String userId) async {
    final batch = firestore.batch();
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .get();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
