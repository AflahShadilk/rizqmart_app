import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/user_profile_repository.dart';

class UploadProfilePhotoUsecase {
  final UserProfileRepository repository;
  const UploadProfilePhotoUsecase(this.repository);
  Future<String>call(String userId, FilePickerResult file)async{
    return await repository.uploadProfilePhoto(userId, file);
  }

}