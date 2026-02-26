
import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/data/model/main/notification_model.dart';

/// Base abstract class representing the various states of notification data.
abstract class NotificationState extends Equatable {
  const NotificationState();
  
  @override
  List<Object> get props => [];
}

class NotificationInitialState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationLoadedState({required this.notifications, required this.unreadCount});
  
  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationErrorState extends NotificationState {
  final String message;

  const NotificationErrorState(this.message);
  
  @override
  List<Object> get props => [message];
}
