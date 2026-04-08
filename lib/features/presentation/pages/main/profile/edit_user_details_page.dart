import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/presentation/cubits/profile/dob/date_of_birth_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/profile/gender/gender_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/profile/profilephoto/profile_photo_upload_cubit.dart';
import 'package:rizqmart/features/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/profile/user_profile_state.dart';
import 'package:rizqmart/features/presentation/cubits/profile/edit_profile_form_cubit.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/widget/profile_photo.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/widget/edit_basic_info_section.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/widget/edit_personal_details_section.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/widget/edit_about_you_section.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/widget/edit_save_button.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/back_button_common.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/presentation/widgets/common/show_toast_actions.dart';

// ---------------- Edit User Details Page ----------------

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

  // ---------------- Controllers & Variables ----------------

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late DateOfBirthCubit dateOfBirthCubit;
  late GenderCubit genderCubit;
  late EditProfileFormCubit editProfileFormCubit;

  final formKey = GlobalKey<FormState>();

  // ---------------- Init State ----------------

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

  // ---------------- Dispose ----------------

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

  // ---------------- Helper Methods ----------------

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

  // ---------------- Build Method ----------------

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

// ---------------- Edit Details Content Widget ----------------

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

  // ---------------- Build Method ----------------

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
              EditBasicInfoSection(
                nameController: nameController,
                emailController: emailController,
                phoneController: phoneController,
              ),
              20.h,
              EditPersonalDetailsSection(
                dateOfBirthCubit: dateOfBirthCubit,
                genderCubit: genderCubit,
              ),
              20.h,
              EditAboutYouSection(
                bioController: bioController,
              ),
              28.h,
              EditSaveButton(onSave: onSave),
              16.h,
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Helper Methods ----------------

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
}