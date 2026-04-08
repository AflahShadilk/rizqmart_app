import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/repositories/main/user_profile_repository.dart';

/// Use case for uploading a new avatar image to replace the user's profile photo.
class UploadProfilePhotoUsecase {
  final UserProfileRepository repository;
  const UploadProfilePhotoUsecase(this.repository);
  Future<Either<Failure, String>> call(String userId, FilePickerResult file) async {
    return await repository.uploadProfilePhoto(userId, file);
  }
}