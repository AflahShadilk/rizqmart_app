import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';

/// Base abstract class handling profile fetch, update, and deletion actions.
abstract class UserProfileEvent extends Equatable{
  const UserProfileEvent();
  @override
  
  List<Object?> get props => [];
}
class LoadUserProfileEvent extends UserProfileEvent {
  final String userId;

  const LoadUserProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateUserProfileEvent extends UserProfileEvent {
  final UserProfileEntities profile;

  const UpdateUserProfileEvent({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class UploadProfilePhotoEvent extends UserProfileEvent {
  final String userId;
  final FilePickerResult file;

  const UploadProfilePhotoEvent({
    required this.userId,
    required this.file,
  });

  @override
  List<Object?> get props => [userId, file];
}

class DeleteProfilePhotoEvent extends UserProfileEvent {
  final String userId;

  const DeleteProfilePhotoEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}