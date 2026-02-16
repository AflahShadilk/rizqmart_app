

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/search_bar.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/notification_button.dart';

Container topBarItems(
  BuildContext context,
  searchController,
  Function(String) onSearch,
) {
  final size = MediaQuery.of(context).size;
  final currentUser = FirebaseAuth.instance.currentUser;
  final isLoggedIn = currentUser != null;

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).appBarTheme.foregroundColor,
      boxShadow: [
        BoxShadow(
          color: context.cs.primary.withValues(alpha: 0.10),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        60.h,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              SizedBox(
                width: size.width * 0.1,
                child: const ClipRRect(
                  child: Image(
                    image: AssetImage('assets/icons_and_images/carrot.png'),
                  ),
                ),
              ),

              
              GestureDetector(
                onTap: () {
                   context.read<AddressBloc>().add(GetCurrentLocationEvent());
                },
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    String locationText = 'Your Location';
                    if (state is LocationLoadedState) {
                      locationText = state.addressName ?? 'Unknown Location';
                    } else if (state is LocationLoadingState) {
                      locationText = 'Locating...';
                    }
                
                    return Row(
                      mainAxisSize: MainAxisSize.min, 
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: context.cs.secondary,
                        ),
                        4.w,
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: size.width * 0.4),
                          child: Text(
                            locationText,
                            style: context.ts.bodyMedium?.copyWith(
                              color: context.cs.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              
              
              
              
              
              
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const NotificationButton(),
                  12.w,
                  isLoggedIn
                      ? buildProfileButton(context)
                      : buildLoginButton(context),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 13, 15, 8),
          child: SearchField(
            controller: searchController,
            onChanged: onSearch,
          ),
        ),
      ],
    ),
  );
}

Widget buildProfileButton(BuildContext context) {
  final currentUser = FirebaseAuth.instance.currentUser;
  final photoUrl = currentUser?.photoURL ?? '';

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, AppRoutes.profile);
    },
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.cs.secondary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.cs.secondary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: photoUrl.isNotEmpty
            ? ProductImage(
                imageUrl: photoUrl,
                width: 40,
                height: 40,
                borderRadius: BorderRadius.circular(50),
              )
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      context.cs.secondary,
                      context.cs.secondary.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: context.cs.onSecondary,
                    size: 20,
                  ),
                ),
              ),
      ),
    ),
  );
}

Widget buildLoginButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.cs.primary,
          width: 1.5,
        ),
      ),
      child: Text(
        'Login',
        style: context.ts.labelMedium?.copyWith(
          color: context.cs.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget buildNotificationButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      
    },
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.cs.surfaceContainerHighest, 
      ),
      child: Center(
        child: Icon(
          Icons.notifications_none_rounded,
          color: context.cs.onSurfaceVariant,
          size: 24,
        ),
      ),
    ),
  );
}