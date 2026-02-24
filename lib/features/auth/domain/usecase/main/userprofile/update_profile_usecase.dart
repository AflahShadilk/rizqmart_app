import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/user_profile_repository.dart';

class UpdateProfileUsecase {
  final UserProfileRepository repository;
  const UpdateProfileUsecase(this.repository);
  Future<Either<Failure, UserProfileEntities>> call(UserProfileEntities profile) async {
    return await repository.updateProfile(profile);
  }
}