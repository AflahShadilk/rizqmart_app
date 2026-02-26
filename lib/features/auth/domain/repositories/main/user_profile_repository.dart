import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';

/// Abstract repository defining operations for retrieving and updating user profile data.
abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileEntities>> getUserProfile(String userId);
  Future<Either<Failure, UserProfileEntities>> updateProfile(UserProfileEntities profile);
  Future<Either<Failure, String>> uploadProfilePhoto(String userId, FilePickerResult file);
  Future<Either<Failure, void>> deleteProfilePhoto(String userId);
}