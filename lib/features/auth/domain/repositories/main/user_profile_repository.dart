import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';

abstract class UserProfileRepository {
  Future<UserProfileEntities> getUserProfile(String userId);
  Future<UserProfileEntities> updateProfile(UserProfileEntities profile);
  Future<String> uploadProfilePhoto(String userId, FilePickerResult file);
  Future<void> deleteProfilePhoto(String userId);
}