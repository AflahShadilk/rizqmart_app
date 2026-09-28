import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/notification/notification_state.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/notification_dropdown_header.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/notification_dropdown_footer.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/dropdown_notification_empty_state.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/dropdown_notification_item.dart';

// ---------------- Controllers & Classes ----------------

/// A dropdown overlay widget displaying a quick preview of recent user notifications.
/// Width is clamped against the screen width so it never overflows on smaller devices.
class NotificationDropdown extends StatelessWidget {
  final VoidCallback? onClose;
  const NotificationDropdown({super.key, this.onClose});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Panel is 320px on wide screens; on narrow screens (< 360px) shrink to fit with 16px margins
    final panelWidth = screenWidth < 360 ? screenWidth - 32 : 320.0;
    // Panel height caps at 60% of screen height so it never clips bottom on short devices
    final maxPanelHeight = screenHeight * 0.60;

    return Container(
      width: panelWidth,
      constraints: BoxConstraints(maxHeight: maxPanelHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NotificationDropdownHeader(),
            const Divider(height: 1, thickness: 1, color: AppColors.dividerGray),
            Flexible(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoadingState) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    );
                  }
                  if (state is NotificationLoadedState) {
                    if (state.notifications.isEmpty) {
                      return const DropdownNotificationEmptyState();
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      // Cap at 5 items in the dropdown preview
                      itemCount: state.notifications.length > 5 ? 5 : state.notifications.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.dividerGray,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return DropdownNotificationItem(notification: notification);
                      },
                    );
                  }
                  if (state is NotificationErrorState) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'Failed to load notifications',
                          style: TextStyle(
                            color: AppColors.statusCancelled,
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
            const Divider(height: 1, thickness: 1, color: AppColors.dividerGray),
            NotificationDropdownFooter(onClose: onClose),
          ],
        ),
      ),
    );
  }
}
