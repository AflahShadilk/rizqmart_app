import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/user_profile_repository.dart';
class DeleteProfilePhotoUsecase {
  final UserProfileRepository repository;
  const DeleteProfilePhotoUsecase(this.repository);
  Future<Either<Failure, void>> call(String userId) async {
    return await repository.deleteProfilePhoto(userId);
  }
}