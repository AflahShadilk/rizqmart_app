import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/dob/date_of_birth_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/gender/gender_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_menu_item.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _initializeProfileBloc();
  }

  void _initializeProfileBloc() {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null || userId.isEmpty) {
        showToast(context, 'User not authenticated');
        return;
      }

      _profileBloc = UserProfileBloc(
        getUserProfileUsecase: sl(),
        uploadProfilePhotoUsecase: sl(),
        updateProfileUsecase: sl(),
        deleteProfilePhotoUsecase: sl(),
      );

      _profileBloc.add(LoadUserProfileEvent(userId: userId));
    } catch (e) {
      showToast(context, 'Error loading profile');
    }
  }

  @override
  void dispose() {
    if (!_profileBloc.isClosed) {
      _profileBloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DateOfBirthCubit(null),
          ),
          BlocProvider(
            create: (context) => GenderCubit(null),
          ),
        ],
        child: Scaffold(
          backgroundColor: context.cs.surface,
          body: BlocConsumer<UserProfileBloc, UserProfileState>(
            listener: (context, state) {
              if (state is UserProfileErrorState) {
                showToast(context, state.message);
              }
            },
            builder: (context, state) {
              return switch (state) {
                UserProfileLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                UserProfileLoadedState() => _buildProfileContent(
                    context,
                    state.profile,
                  ),
                _ => Center(
                    child: Text(
                      'Unable to load profile',
                      style: context.ts.bodyLarge,
                    ),
                  ),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, dynamic profile) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileHeader(
              photoUrl: profile.photoUrl ?? '',
              name: profile.name,
              email: profile.email,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ProfileMenuList(
                userProfileBloc: _profileBloc,
              ),
            ),
          ],
        ),
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
          ProductImage(
            imageUrl: photoUrl.isEmpty ? null : photoUrl,
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(50),
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

class ProfileMenuList extends StatelessWidget {
  final UserProfileBloc userProfileBloc;

  const ProfileMenuList({
    super.key,
    required this.userProfileBloc,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final menuItems = [
      ProfileMenuItem(
        icon: Icons.shopping_bag,
        title: 'Orders',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.person_outline,
        title: 'My Details',
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.profileDetails,
            arguments: userProfileBloc,
          );
        },
      ),
      ProfileMenuItem(
        icon: Icons.location_on,
        title: 'Delivery Address',
        onTap: () {
          if (userId.isEmpty) {
            showToast(context, 'User not authenticated');
            return;
          }
          Navigator.pushNamed(
            context,
            AppRoutes.userAddress,
            arguments: userId,
          );
        },
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
      separatorBuilder: (context, index) => 8.h,
      itemBuilder: (context, index) => menuItems[index],
    );
  }
}