import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';

// ---------------- Profile Header Widget ----------------

class ProfileHeader extends StatelessWidget {
  final String photoUrl;
  final String name;
  final String email;

  const ProfileHeader({
    super.key,
    required this.photoUrl,
    required this.name,
    required this.email,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.profileDetails,
                arguments: context.read<UserProfileBloc>(),
              );
            },
            child: Stack(
              children: [
                ProductImage(
                  imageUrl: photoUrl.isEmpty ? null : photoUrl,
                  width: 80,
                  height: 80,
                  borderRadius: BorderRadius.circular(50),
                  fallbackName: name,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.cs.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.cs.surfaceContainerHighest, width: 2),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 14,
                      color: context.cs.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          16.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.ts.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.h,
                Text(
                  email,
                  style: context.ts.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
