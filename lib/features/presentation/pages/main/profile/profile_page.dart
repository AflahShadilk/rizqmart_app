import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/di/register.dart';
import 'package:rizqmart/features/presentation/cubits/profile/dob/date_of_birth_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/profile/gender/gender_cubit.dart';
import 'package:rizqmart/features/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/profile/user_profile_event.dart';
import 'package:rizqmart/features/presentation/bloc/main/profile/user_profile_state.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/widget/profile_header.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/widget/profile_logout_button.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/widget/profile_options_list.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/common/show_toast_actions.dart';


// ---------------- Profile Page ----------------

/// The primary user account screen displaying the profile summary and a menu of account-related settings.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  // ---------------- Variables ----------------
  
  late UserProfileBloc profileBloc;

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    initializeProfileBloc();
  }

  // ---------------- Helper Methods ----------------

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

  // ---------------- Dispose ----------------

  @override
  void dispose() {
    if (!profileBloc.isClosed) {
      profileBloc.close();
    }
    super.dispose();
  }

  // ---------------- Build Method ----------------

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
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------------- Profile Header ----------------
            ProfileHeader(
              photoUrl: profile.photoUrl ?? '',
              name: profile.name,
              email: profile.email,
            ),
            32.h,
            // ---------------- Profile Options List ----------------
            Expanded(
              child: ProfileOptionsList(profileBloc: profileBloc),
            ),
            // ---------------- Logout Button ----------------
            SizedBox(
              width: size.width * 0.9,
              child: const ProfileLogoutButton(),
            )
          ],
        ),
      ),
    );
  }
}