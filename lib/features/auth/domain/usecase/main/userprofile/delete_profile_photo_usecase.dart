import 'package:rizqmart/features/auth/domain/repositories/main/user_profile_repository.dart';

class DeleteProfilePhotoUsecase {
  final UserProfileRepository repository;
  const DeleteProfilePhotoUsecase(this.repository);
  Future<void>call(String userId)async{
    return await repository.deleteProfilePhoto(userId);
  }
}