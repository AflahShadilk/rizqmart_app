import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/user_profile_repository.dart';

/// Use case for submitting changes to a user's existing profile details.
class UpdateProfileUsecase {
  final UserProfileRepository repository;
  const UpdateProfileUsecase(this.repository);
  Future<Either<Failure, UserProfileEntities>> call(UserProfileEntities profile) async {
    return await repository.updateProfile(profile);
  }
}