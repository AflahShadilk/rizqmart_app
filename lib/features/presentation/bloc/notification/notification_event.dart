import 'package:rizqmart/features/data/model/main/notification_model.dart';
import 'package:equatable/equatable.dart';

/// Base abstract class for all events handled by the [NotificationBloc].
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  final String userId;
  const LoadNotificationsEvent(this.userId);
}

class MarkAsReadEvent extends NotificationEvent {
  final String userId;
  final String notificationId;
  const MarkAsReadEvent({required this.userId, required this.notificationId});
}

class MarkAllAsReadEvent extends NotificationEvent {
  final String userId;
  const MarkAllAsReadEvent(this.userId);
}



class NotificationsUpdatedEvent extends NotificationEvent {
  final List<NotificationModel> notifications;
  const NotificationsUpdatedEvent(this.notifications);
}

class NotificationErrorEvent extends NotificationEvent {
  final String message;
  const NotificationErrorEvent(this.message);
}

class ClearAllNotificationsEvent extends NotificationEvent {
  final String userId;
  const ClearAllNotificationsEvent(this.userId);
}
