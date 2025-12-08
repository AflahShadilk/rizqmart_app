import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/show_details.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class ShowDetailsPage extends StatelessWidget {
  const ShowDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailsEditCubit(),
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
            }
            if (state is UserProfileLoadedState) {
              context.read<UserDetailsEditCubit>().setEditMode(false);
              showToast(context, 'Profile updated successfully');
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
  DateTime? selectedDateOfBirth;
  String? selectedGender;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    phoneController =
        TextEditingController(text: widget.profile.phoneNumber ?? '');
    emailController = TextEditingController(text: widget.profile.email);
    bioController = TextEditingController(text: widget.profile.bio ?? '');
    selectedDateOfBirth = widget.profile.dateOfBirth;
    selectedGender = widget.profile.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void saveProfile() {
    if (formKey.currentState!.validate()) {
      final updatedProfile = UserProfileEntities(
        userId: widget.profile.userId,
        name: nameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text.isEmpty ? null : phoneController.text,
        photoUrl: widget.profile.photoUrl,
        bio: bioController.text.isEmpty ? null : bioController.text,
        dateOfBirth: selectedDateOfBirth,
        gender: selectedGender,
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
                  DateOfBirthField(
                    selectedDate: selectedDateOfBirth,
                    enabled: isEditing,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDateOfBirth = date;
                      });
                    },
                  ),
                  16.h,
                  GenderSelector(
                    selectedGender: selectedGender,
                    enabled: isEditing,
                    onGenderSelected: (gender) {
                      setState(() {
                        selectedGender = gender;
                      });
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

class ProfilePhotoSection extends StatelessWidget {
  final String photoUrl;
  final String userId;
  final bool isEditing;

  const ProfilePhotoSection({
    super.key,
    required this.photoUrl,
    required this.userId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: photoUrl.isNotEmpty
                ? Image.network(
                    photoUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        color: context.cs.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: context.cs.onPrimaryContainer,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 120,
                    height: 120,
                    color: context.cs.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: context.cs.onPrimaryContainer,
                    ),
                  ),
          ),
          if (isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.cs.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.cs.surface,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: context.cs.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool enabled;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.enabled,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: context.ts.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.ts.bodyMedium?.copyWith(
          color: context.cs.onSurfaceVariant,
        ),
        prefixIcon: Icon(icon, color: context.cs.onSurfaceVariant),
        filled: true,
        fillColor: enabled
            ? context.cs.surfaceContainerHighest
            : context.cs.surfaceContainerHighest.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.cs.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.cs.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.cs.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class DateOfBirthField extends StatelessWidget {
  final DateTime? selectedDate;
  final bool enabled;
  final Function(DateTime?) onDateSelected;

  const DateOfBirthField({
    super.key,
    required this.selectedDate,
    required this.enabled,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              onDateSelected(date);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: enabled
              ? context.cs.surfaceContainerHighest
              : context.cs.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: context.cs.onSurfaceVariant,
            ),
            16.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date of Birth',
                    style: context.ts.bodyMedium?.copyWith(
                      color: context.cs.onSurfaceVariant,
                    ),
                  ),
                  4.h,
                  Text(
                    selectedDate != null
                        ? MaterialLocalizations.of(context)
                            .formatShortDate(selectedDate!)
                        : 'Not set',
                    style: context.ts.bodyLarge,
                  ),
                ],
              ),
            ),
            if (enabled)
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

class GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final bool enabled;
  final Function(String?) onGenderSelected;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.enabled,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: enabled
            ? context.cs.surfaceContainerHighest
            : context.cs.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people_outline,
                color: context.cs.onSurfaceVariant,
              ),
              16.w,
              Text(
                'Gender',
                style: context.ts.bodyMedium?.copyWith(
                  color: context.cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          8.h,
          Row(
            children: [
              Expanded(
                child: GenderOption(
                  label: 'Male',
                  isSelected: selectedGender == 'Male',
                  enabled: enabled,
                  onTap: () => onGenderSelected('Male'),
                ),
              ),
              12.w,
              Expanded(
                child: GenderOption(
                  label: 'Female',
                  isSelected: selectedGender == 'Female',
                  enabled: enabled,
                  onTap: () => onGenderSelected('Female'),
                ),
              ),
              12.w,
              Expanded(
                child: GenderOption(
                  label: 'Other',
                  isSelected: selectedGender == 'Other',
                  enabled: enabled,
                  onTap: () => onGenderSelected('Other'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const GenderOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? context.cs.primaryContainer : context.cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? context.cs.primary : context.cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: context.ts.bodyMedium?.copyWith(
              color: isSelected
                  ? context.cs.onPrimaryContainer
                  : context.cs.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
