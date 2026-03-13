import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/data/model/main/notification_model.dart';
import 'package:rizqmart/features/auth/data/repository/main/notification_repository.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_state.dart';
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;
  StreamSubscription<Either<Failure, List<NotificationModel>>>? _notificationsSubscription;

  NotificationBloc(this.repository) : super(NotificationInitialState()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<NotificationsUpdatedEvent>(_onNotificationsUpdated);
    on<NotificationErrorEvent>(_onNotificationError);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<ClearAllNotificationsEvent>(_onClearAllNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoadingState());
    
    await _notificationsSubscription?.cancel();
    _notificationsSubscription = repository.getNotifications(event.userId).listen(
      (result) {
        result.fold(
          (failure) => add(NotificationErrorEvent(failure.message)),
          (notifications) => add(NotificationsUpdatedEvent(notifications)),
        );
      },
      onError: (error) {
        add(NotificationErrorEvent(error.toString()));
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

  void _onNotificationError(
    NotificationErrorEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationErrorState(event.message));
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await repository.markAsRead(event.userId, event.notificationId);
    result.fold(
      (failure) => emit(NotificationErrorState(failure.message)),
      (_) => null,
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await repository.markAllAsRead(event.userId);
    result.fold(
      (failure) => emit(NotificationErrorState(failure.message)),
      (_) => null,
    );
  }

  Future<void> _onClearAllNotifications(
    ClearAllNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await repository.clearAllNotifications(event.userId);
    result.fold(
      (failure) => emit(NotificationErrorState(failure.message)),
      (_) => null,
    );
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
