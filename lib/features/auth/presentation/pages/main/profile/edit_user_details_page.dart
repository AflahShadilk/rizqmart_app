

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/dob/date_of_birth_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/gender/gender_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/profilephoto/profile_photo_upload_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/edit_profile_form_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/date_of_birth_field.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/genden/gender_selection.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_photo.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_text_field.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/back_button_common.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

/// A form page enabling users to update their personal information, bio, and profile photo.
class EditUserDetailsPage extends StatefulWidget {
  final UserProfileBloc profileBloc;

  const EditUserDetailsPage({
    super.key,
    required this.profileBloc,
  });

  @override
  State<EditUserDetailsPage> createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late DateOfBirthCubit dateOfBirthCubit;
  late GenderCubit genderCubit;
  late EditProfileFormCubit editProfileFormCubit;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final currentState = widget.profileBloc.state;
    
    if (currentState is UserProfileLoadedState) {
      final profile = currentState.profile;
      nameController = TextEditingController(text: profile.name);
      phoneController = TextEditingController(text: profile.phoneNumber ?? '');
      emailController = TextEditingController(text: profile.email);
      bioController = TextEditingController(text: profile.bio ?? '');
      dateOfBirthCubit = DateOfBirthCubit(profile.dateOfBirth);
      genderCubit = GenderCubit(profile.gender);
    } else {
      nameController = TextEditingController();
      phoneController = TextEditingController();
      emailController = TextEditingController();
      bioController = TextEditingController();
      dateOfBirthCubit = DateOfBirthCubit(null);
      genderCubit = GenderCubit(null);
    }
    editProfileFormCubit = EditProfileFormCubit(profileBloc: widget.profileBloc);
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
      editProfileFormCubit.saveProfile(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        bio: bioController.text,
        dateOfBirth: dateOfBirthCubit.state,
        gender: genderCubit.state,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.profileBloc),
        BlocProvider(create: (context) => ProfilePhotoUploadCubit()),
      ],
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          backgroundColor: context.cs.surface,
          elevation: 0,
          leading: BackButtonCommon(colorScheme: context.cs),
          title: AppHeading('Edit Details'),
          centerTitle: true,
        ),
        body: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileErrorState) {
              showToast(context, state.message);
              context.read<ProfilePhotoUploadCubit>().stopUploading();
            }
            if (state is UserProfileLoadedState) {
              showToast(context, 'Profile updated successfully');
              context.read<ProfilePhotoUploadCubit>().stopUploading();
              Navigator.pop(context);
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
              return _EditDetailsContent(
                profile: state.profile,
                nameController: nameController,
                phoneController: phoneController,
                emailController: emailController,
                bioController: bioController,
                dateOfBirthCubit: dateOfBirthCubit,
                genderCubit: genderCubit,
                formKey: formKey,
                onSave: saveProfile,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _EditDetailsContent extends StatelessWidget {
  final UserProfileEntities profile;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final DateOfBirthCubit dateOfBirthCubit;
  final GenderCubit genderCubit;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSave;

  const _EditDetailsContent({
    required this.profile,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.bioController,
    required this.dateOfBirthCubit,
    required this.genderCubit,
    required this.formKey,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildProfilePhotoSection(context),
              28.h,
              _buildSectionTitle(context, 'Basic Information'),
              14.h,
              ProfileTextField(
                controller: nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                enabled: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                helperText: '',
              ),
              12.h,
              ProfileTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                helperText: 'Email cannot be changed',
              ),
              12.h,
              ProfileTextField(
                controller: phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                enabled: true,
                keyboardType: TextInputType.phone,
                helperText: '',
              ),
              20.h,
              _buildSectionTitle(context, 'Personal Details'),
              14.h,
              BlocBuilder<DateOfBirthCubit, DateTime?>(
                bloc: dateOfBirthCubit,
                builder: (context, selectedDate) {
                  return DateOfBirthField(
                    selectedDate: selectedDate,
                    enabled: true,
                    onDateSelected: (date) {
                      dateOfBirthCubit.setDate(date);
                    },
                  );
                },
              ),
              12.h,
              BlocBuilder<GenderCubit, String?>(
                bloc: genderCubit,
                builder: (context, selectedGender) {
                  return GenderSelector(
                    selectedGender: selectedGender,
                    enabled: true,
                    onGenderSelected: (gender) {
                      genderCubit.setGender(gender);
                    },
                  );
                },
              ),
              20.h,
              _buildSectionTitle(context, 'About You'),
              14.h,
              ProfileTextField(
                controller: bioController,
                label: 'Bio',
                icon: Icons.info_outline,
                enabled: true,
                maxLines: 3,
                helperText: 'Tell us about yourself',
              ),
              28.h,
              _buildSaveButton(context),
              16.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePhotoSection(
            photoUrl: profile.photoUrl ?? '',
            userId: profile.userId,
            isEditing: true,
          ),
          10.h,
          Text(
            profile.name,
            style: context.ts.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.cs.onSurface,
            ),
          ),
          4.h,
          Text(
            profile.email,
            style: context.ts.bodySmall?.copyWith(
              color: context.cs.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: context.ts.labelLarge?.copyWith(
          color: context.cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.cs.primary,
          foregroundColor: context.cs.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          'Save Changes',
          style: context.ts.labelLarge?.copyWith(
            color: context.cs.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}