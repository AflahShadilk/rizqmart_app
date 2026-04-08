import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rizqmart/features/data/error/error_handler.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/data/data_source/main/user_profile_data_source.dart';
import 'package:rizqmart/features/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/user_profile_repository.dart';

/// Repository implementation facilitating user profile data updates and interactions with remote storage.
class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDataSource remoteDataSource;

  const UserProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, UserProfileEntities>> getUserProfile(String userId) {
    return ErrorHandler.executeApiCall(() async {
      return await remoteDataSource.getUserProfile(userId);
    });
  }

  @override
  Future<Either<Failure, UserProfileEntities>> updateProfile(UserProfileEntities profile) {
    return ErrorHandler.executeApiCall(() async {
      return await remoteDataSource.updateProfile(profile);
    });
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(String userId, FilePickerResult file) {
    return ErrorHandler.executeApiCall(() async {
      return await remoteDataSource.uploadProfilePhoto(userId, file);
    });
  }

  @override
  Future<Either<Failure, void>> deleteProfilePhoto(String userId) {
    return ErrorHandler.executeApiCall(() async {
      await remoteDataSource.deleteProfilePhoto(userId);
    });
  }
}
