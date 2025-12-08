import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileErrorState) {
            showToast(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is UserProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UserProfileLoadedState) {
            final userProfile = state.profile;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileHeader(
                      photoUrl: userProfile.photoUrl ?? '',
                      name: userProfile.name,
                      email: userProfile.email,
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: ProfileMenuList(),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

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
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: photoUrl.isNotEmpty
                ? Image.network(
                    photoUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: context.cs.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: context.cs.onPrimaryContainer,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: context.cs.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: context.cs.onPrimaryContainer,
                    ),
                  ),
          ),
          16.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.ts.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
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

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      ProfileMenuItem(
        icon: Icons.shopping_bag,
        title: 'Orders',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.person_outline,
        title: 'My Details',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.location_on,
        title: 'Delivery Address',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.payment_outlined,
        title: 'Payment Method',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.local_offer_outlined,
        title: 'Promo code',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.help_outline,
        title: 'Help',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.info_outline,
        title: 'About',
        onTap: () {},
      ),
    ];

    return ListView.separated(
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return menuItems[index];
      },
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: context.cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.cs.onSurface,
              size: 24,
            ),
            16.w,
            Expanded(
              child: Text(
                title,
                style: context.ts.bodyLarge,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: context.cs.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}