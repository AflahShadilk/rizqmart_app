import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/dob/date_of_birth_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/gender/gender_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_menu_item.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/dialogs/logout_dailog.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    initializeProfileBloc();
  }

  void initializeProfileBloc() {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null || userId.isEmpty) {
        showToast(context, 'User not authenticated');
        return;
      }

      profileBloc = UserProfileBloc(
        getUserProfileUsecase: sl(),
        uploadProfilePhotoUsecase: sl(),
        updateProfileUsecase: sl(),
        deleteProfilePhotoUsecase: sl(),
      );

      profileBloc.add(LoadUserProfileEvent(userId: userId));
    } catch (e) {
      showToast(context, 'Error loading profile');
    }
  }

  @override
  void dispose() {
    if (!profileBloc.isClosed) {
      profileBloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: profileBloc,
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
                UserProfileLoadedState() => buildProfileContent(
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

  Widget buildProfileContent(BuildContext context, dynamic profile) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildProfileHeader(
              context,
              profile.photoUrl ?? '',
              profile.name,
              profile.email,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: buildProfileMenuList(context),
            ),
            SizedBox(
              width: size.width * 0.9,
              child: BlocListener<SignOutBloc, SignOutState>(
                listener: (context, state) {
                  if (state is LoadingSignOutState) {
                    showLoadingDialog(context);
                    return;
                  }
                  Navigator.of(context, rootNavigator: true).pop();
                  if (state is SignOutFailureState) {
                    showToast(
                      context,
                      state.error,
                      type: ToastType.error,
                    );
                  }
                  if (state is SignOutSuccessState) {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                },
                child: MainButton(
                  label: 'Log Out',
                  onPress: () {
                    context.read<SignOutBloc>().add(SignOutRequestedEvent());
                  },
                  color: context.cs.primary,
                  textColor: context.cs.surface,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProfileHeader(
    BuildContext context,
    String photoUrl,
    String name,
    String email,
  ) {
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

  Widget buildProfileMenuList(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final menuItems = [
      buildProfileMenuItem(
        icon: Icons.shopping_bag,
        title: 'Orders',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.orders);
        },
      ),
      buildProfileMenuItem(
        icon: Icons.person_outline,
        title: 'My Details',
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.profileDetails,
            arguments: profileBloc,
          );
        },
      ),
      buildProfileMenuItem(
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
      buildProfileMenuItem(
        icon: Icons.payment_outlined,
        title: 'Payment Method',
        onTap: () {},
      ),
      buildProfileMenuItem(
        icon: Icons.local_offer_outlined,
        title: 'Promo code',
        onTap: () {},
      ),
      buildProfileMenuItem(
        icon: Icons.settings_outlined,
        title: 'Settings',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.settings);
        },
      ),
      buildProfileMenuItem(
        icon: Icons.help_outline,
        title: 'Help',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.help);
        },
      ),
      buildProfileMenuItem(
        icon: Icons.info_outline,
        title: 'About',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.aboutUs);
        },
      ),
    ];

    return ListView.separated(
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => 8.h,
      itemBuilder: (context, index) => menuItems[index],
    );
  }

  Widget buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ProfileMenuItem(
      icon: icon,
      title: title,
      onTap: onTap,
    );
  }
}