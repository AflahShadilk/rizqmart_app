import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- Notification Dropdown Footer Widget ----------------

/// Footer widget for the notification dropdown, providing a link to view all notifications.
class NotificationDropdownFooter extends StatelessWidget {
  final VoidCallback? onClose;

  const NotificationDropdownFooter({super.key, this.onClose});

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
     return InkWell(
       onTap: () {
         onClose?.call();
         Navigator.pushNamed(context, '/notifications');
       },
       child: Container(
         padding: const EdgeInsets.symmetric(vertical: 10),
         alignment: Alignment.center,
         decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
             colors: [
               Colors.transparent,
               Colors.white.withValues(alpha: 0.02),
             ],
           ),
         ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(
               'View all',
               style: context.ts.labelMedium?.copyWith(
                 color: context.cs.primary,
                 fontWeight: FontWeight.w600,
                 fontSize: 12,
               ),
             ),
             4.w,
             Icon(
               Icons.arrow_forward_rounded, 
               size: 14, 
               color: context.cs.primary,
             ),
           ],
         ),
       ),
     );
  }
}
