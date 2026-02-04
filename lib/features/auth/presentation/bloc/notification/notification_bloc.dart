
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/data/repository/notification_repository.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;
  StreamSubscription? _notificationsSubscription;

  NotificationBloc(this.repository) : super(NotificationInitialState()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<NotificationsUpdatedEvent>(_onNotificationsUpdated);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoadingState());
    
    await _notificationsSubscription?.cancel();
    _notificationsSubscription = repository.getNotifications(event.userId).listen(
      (notifications) {
        add(NotificationsUpdatedEvent(notifications));
      },
      onError: (error) {
        // Handle stream error if needed, for instance dispatching an error state
        // For now, we rely on the updated event or could add an Error event
      },
    );
  }

  void _onNotificationsUpdated(
    NotificationsUpdatedEvent event,
    Emitter<NotificationState> emit,
  ) {
    final notifications = event.notifications;
    // Actually event.notifications is List<dynamic> in definition but Repository returns List<NotificationModel>
    // Let's fix the event definition or just cast here. 
    // In event file I put List<dynamic>, better to fix that import but casting works.
    
    // Calculate unread count
    final unreadCount = notifications.where((n) => !n.isRead).length;
    
    emit(NotificationLoadedState(
      notifications: notifications,
      unreadCount: unreadCount,
    ));
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.markAsRead(event.userId, event.notificationId);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.markAllAsRead(event.userId);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
