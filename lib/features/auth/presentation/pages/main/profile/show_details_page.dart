// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/dob/date_of_birth_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/gender/gender_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/profilephoto/profile_photo_upload_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/show_details.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/date_of_birth_field.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/genden/gender_selection.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_photo.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_text_field.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';


class ShowDetailsPage extends StatelessWidget {
  final UserProfileBloc profileBloc;

  const ShowDetailsPage({
    super.key,
    required this.profileBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: profileBloc),
        BlocProvider(create: (context) => UserDetailsEditCubit()),
        BlocProvider(create: (context) => ProfilePhotoUploadCubit()),
      ],
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          backgroundColor: context.cs.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.cs.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'My Details',
            style: context.ts.titleLarge,
          ),
          actions: [
            BlocBuilder<UserDetailsEditCubit, bool>(
              builder: (context, isEditing) {
                return IconButton(
                  icon: Icon(
                    isEditing ? Icons.close : Icons.edit,
                    color: context.cs.onSurface,
                  ),
                  onPressed: () {
                    context.read<UserDetailsEditCubit>().toggleEditMode();
                  },
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileErrorState) {
              showToast(context, state.message);
              context.read<ProfilePhotoUploadCubit>().stopUploading();
            }
            if (state is UserProfileLoadedState) {
              context.read<UserDetailsEditCubit>().setEditMode(false);
              showToast(context, 'Profile updated successfully');
              context.read<ProfilePhotoUploadCubit>().stopUploading();
            }
            if (state is UserProfilePhotoUploadedState) {
              showToast(context, 'Photo uploaded successfully');
              context.read<ProfilePhotoUploadCubit>().stopUploading();
            }
          },
          builder: (context, state) {
            if (state is UserProfileLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UserProfileLoadedState) {
              return UserDetailsContent(profile: state.profile);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class UserDetailsContent extends StatefulWidget {
  final UserProfileEntities profile;

  const UserDetailsContent({
    super.key,
    required this.profile,
  });

  @override
  State<UserDetailsContent> createState() => _UserDetailsContentState();
}

class _UserDetailsContentState extends State<UserDetailsContent> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late DateOfBirthCubit dateOfBirthCubit;
  late GenderCubit genderCubit;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    phoneController =
        TextEditingController(text: widget.profile.phoneNumber ?? '');
    emailController = TextEditingController(text: widget.profile.email);
    bioController = TextEditingController(text: widget.profile.bio ?? '');
    dateOfBirthCubit = DateOfBirthCubit(widget.profile.dateOfBirth);
    genderCubit = GenderCubit(widget.profile.gender);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    bioController.dispose();
    dateOfBirthCubit.close();
    genderCubit.close();
    super.dispose();
  }

  void saveProfile() {
    if (formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        showToast(context, 'Error: User not authenticated');
        return;
      }

      final userId = currentUser.uid;

      if (userId.isEmpty) {
        showToast(context, 'Error: User ID is missing');
        return;
      }

      final updatedProfile = UserProfileEntities(
        userId: userId,
        name: nameController.text,
        email: emailController.text,
        phoneNumber:
            phoneController.text.isEmpty ? null : phoneController.text,
        photoUrl: widget.profile.photoUrl,
        bio: bioController.text.isEmpty ? null : bioController.text,
        dateOfBirth: dateOfBirthCubit.state, 
        gender: genderCubit.state, 
        updatedAt: DateTime.now(),
      );

      context.read<UserProfileBloc>().add(
            UpdateUserProfileEvent(profile: updatedProfile),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsEditCubit, bool>(
      builder: (context, isEditing) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  ProfilePhotoSection(
                    photoUrl: widget.profile.photoUrl ?? '',
                    userId: widget.profile.userId,
                    isEditing: isEditing,
                  ),
                  32.h,
                  ProfileTextField(
                    controller: nameController,
                    label: 'Name',
                    icon: Icons.person_outline,
                    enabled: isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  16.h,
                  ProfileTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    enabled: isEditing,
                    keyboardType: TextInputType.phone,
                  ),
                  16.h,
                  ProfileTextField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    enabled: isEditing,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  16.h,
                  BlocBuilder<DateOfBirthCubit, DateTime?>(
                    bloc: dateOfBirthCubit,
                    builder: (context, selectedDate) {
                      return DateOfBirthField(
                        selectedDate: selectedDate,
                        enabled: isEditing,
                        onDateSelected: (date) {
                          dateOfBirthCubit.setDate(date);
                        },
                      );
                    },
                  ),
                  16.h,
                  BlocBuilder<GenderCubit, String?>(
                    bloc: genderCubit,
                    builder: (context, selectedGender) {
                      return GenderSelector(
                        selectedGender: selectedGender,
                        enabled: isEditing,
                        onGenderSelected: (gender) {
                          genderCubit.setGender(gender);
                        },
                      );
                    },
                  ),
                  16.h,
                  ProfileTextField(
                    controller: bioController,
                    label: 'Bio',
                    icon: Icons.info_outline,
                    enabled: isEditing,
                    maxLines: 3,
                  ),
                  32.h,
                  if (isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.cs.primary,
                          foregroundColor: context.cs.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: context.ts.titleMedium?.copyWith(
                            color: context.cs.onPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}