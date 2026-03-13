

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/notification_dropdown_header.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/notification_dropdown_footer.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/dropdown_notification_empty_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/dropdown_notification_item.dart';
class NotificationDropdown extends StatelessWidget {
  final VoidCallback? onClose;
  const NotificationDropdown({super.key, this.onClose});
@override
  Widget build(BuildContext context) {
    return Container(
      width: 320, 
      constraints: const BoxConstraints(maxHeight: 380),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.cs.surface.withValues(alpha: 0.88),
                  context.cs.surface.withValues(alpha: 0.78),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const NotificationDropdownHeader(),
                Divider(height: 1, color: context.cs.outlineVariant.withValues(alpha: 0.12)),
                Flexible(
                  child: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      if (state is NotificationLoadingState) {
                        return SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.cs.primary,
                            )
                          ),
                        );
                      }
                      if (state is NotificationLoadedState) {
                        if (state.notifications.isEmpty) {
                          return const DropdownNotificationEmptyState();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          itemCount: state.notifications.length > 5 ? 5 : state.notifications.length,
                          itemBuilder: (context, index) {
                            final notification = state.notifications[index];
                            return DropdownNotificationItem(notification: notification);
                          },
                        );
                      }
                      if (state is NotificationErrorState) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'Failed to load notifications', 
                              style: context.ts.bodySmall?.copyWith(
                                color: context.cs.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                Divider(height: 1, color: context.cs.outlineVariant.withValues(alpha: 0.12)),
                NotificationDropdownFooter(onClose: onClose),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

