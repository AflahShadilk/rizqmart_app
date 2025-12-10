// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/profilephoto/profile_photo_upload_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

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

  Future<void> _pickAndUploadImage(BuildContext context) async {
    try {
      final filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (filePickerResult == null || filePickerResult.files.isEmpty) {
        showToast(context, 'No image selected');
        return;
      }

      context.read<ProfilePhotoUploadCubit>().startUploading();

      
      context.read<UserProfileBloc>().add(
            UploadProfilePhotoEvent(
              userId: userId,
              file: filePickerResult,
            ),
          );

      
    } catch (e) {
      showToast(context, 'Error picking image: $e');
      context.read<ProfilePhotoUploadCubit>().stopUploading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePhotoUploadCubit, bool>(
      builder: (context, isUploading) {
        return Center(
          child: Stack(
            children: [
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.cs.primary,
                        ),
                      ),
                    ),
                  ),
                ),

              ProductImage(
                imageUrl: photoUrl.isEmpty ? null : photoUrl,
                width: 120,
                height: 120,
                borderRadius: BorderRadius.circular(60),
              ),

              if (isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: isUploading
                        ? null
                        : () => _pickAndUploadImage(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.cs.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.cs.surface,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.cs.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
      },
    );
  }
}

