
// ignore_for_file: empty_catches

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/data/repository/main/notification_repository.dart';
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
        
        
      },
    );
  }

  void _onNotificationsUpdated(
    NotificationsUpdatedEvent event,
    Emitter<NotificationState> emit,
  ) {
    final notifications = event.notifications;
    
    
    
    
    
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
      
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.markAllAsRead(event.userId);
    } catch (e) {
      
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
