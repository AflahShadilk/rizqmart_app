
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/notification_dropdown.dart';
class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  final OverlayPortalController _overlayController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (context) {
        return Positioned(
          top: 130, 
          right: 70, 
          child: Material(
            elevation: 8,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: NotificationDropdown(
              onClose: () => _overlayController.hide(),
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          _overlayController.toggle();
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.cs.surfaceContainerHighest,
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: context.cs.primary,
                size: 24,
              ),
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoadedState && state.unreadCount > 0) {
                    return Positioned(
                      top: 4,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.cs.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                        child: Text(
                           state.unreadCount > 9 ? '9+' : state.unreadCount.toString(),
                           style: TextStyle(
                             color: context.cs.onError,
                             fontSize: 8,
                             fontWeight: FontWeight.bold,
                           ),
                           textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
