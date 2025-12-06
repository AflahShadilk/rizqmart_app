import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/features/auth/data/data_source/main/user_profile_data_source.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDataSource remoteDataSource;

 const UserProfileRepositoryImpl({
    required  this.remoteDataSource,
  }) ;

  @override
  Future<UserProfileEntities>  getUserProfile(String userId) async {
    try {
      return await remoteDataSource.getUserProfile(userId);
    } catch (e) {
      throw Exception('Repository: Failed to get user profile - $e');
    }
  }

  @override
  Future<UserProfileEntities> updateProfile(UserProfileEntities profile) async {
    try {
      return await remoteDataSource.updateProfile(profile);
    } catch (e) {
      throw Exception('Repository: Failed to update profile - $e');
    }
  }

  @override
  Future<String> uploadProfilePhoto(String userId, FilePickerResult file) async {
    try {
      return await remoteDataSource.uploadProfilePhoto(userId, file);
    } catch (e) {
      throw Exception('Repository: Failed to upload profile photo - $e');
    }
  }

  @override
  Future<void> deleteProfilePhoto(String userId) async {
    try {
      await remoteDataSource.deleteProfilePhoto(userId);
    } catch (e) {
      throw Exception('Repository: Failed to delete profile photo - $e');
    }
  }
}
