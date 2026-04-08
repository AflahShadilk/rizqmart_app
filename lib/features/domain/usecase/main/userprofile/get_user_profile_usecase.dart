import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/domain/repositories/main/user_profile_repository.dart';

/// Use case for fetching the complete detailed profile information of a specific user.
class GetUserProfileUsecase {
  final UserProfileRepository repository;
  const GetUserProfileUsecase(this.repository);
  Future<Either<Failure, UserProfileEntities>> call(String userId) async {
    return await repository.getUserProfile(userId);
  }
}