

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/profilephoto/profile_photo_upload_cubit.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';

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
                      color: Colors.black.withValues(alpha: 0.3),
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

             
            ],
          ),
        );
      },
    );
  }
}

