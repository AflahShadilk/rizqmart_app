

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/profilephoto/profile_photo_upload_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_photo.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/back_button_common.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

/// A read-only view of the user's detailed profile information, including contact details and bio.
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
        BlocProvider(create: (context) => ProfilePhotoUploadCubit()),
      ],
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          backgroundColor: context.cs.surface,
          elevation: 0,
          leading: BackButtonCommon(colorScheme: context.cs),
          title: AppHeading('My Details'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editProfileDetails,
                      arguments: profileBloc,
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.cs.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          color: context.cs.primary,
                          size: 16,
                        ),
                        4.w,
                        Text(
                          'Edit',
                          style: context.ts.labelSmall?.copyWith(
                            color: context.cs.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileErrorState) {
              showToast(context, state.message);
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
              return _UserDetailsViewContent(profile: state.profile);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _UserDetailsViewContent extends StatelessWidget {
  final UserProfileEntities profile;

  const _UserDetailsViewContent({
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            _buildProfilePhotoSection(context),
            28.h,
            _buildSectionTitle(context, 'Basic Information'),
            14.h,
            _buildInfoField(
                context, 'Full Name', profile.name, Icons.person_outline),
            12.h,
            _buildInfoField(
                context, 'Email', profile.email, Icons.email_outlined),
            12.h,
            _buildInfoField(context, 'Phone Number',
                profile.phoneNumber ?? 'Not specified', Icons.phone_outlined),
            20.h,
            _buildSectionTitle(context, 'Personal Details'),
            14.h,
            _buildInfoField(context, 'Date of Birth',
                _formatDate(profile.dateOfBirth), Icons.cake_outlined),
            12.h,
            _buildInfoField(
                context, 'Gender', profile.gender ?? 'Not specified', Icons.wc),
            20.h,
            _buildSectionTitle(context, 'About You'),
            14.h,
            _buildInfoField(context, 'Bio', profile.bio ?? 'Not specified',
                Icons.info_outline),
            28.h,
          ],
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
            isEditing: false,
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

  Widget _buildInfoField(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cs.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.cs.onSurfaceVariant,
            size: 20,
          ),
          16.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.ts.labelSmall?.copyWith(
                    color: context.cs.onSurfaceVariant,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                4.h,
                Text(
                  value,
                  style: context.ts.bodyMedium?.copyWith(
                    color: context.cs.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not specified';
    return '${date.day}/${date.month}/${date.year}';
  }
}
