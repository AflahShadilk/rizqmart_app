import 'package:dartz/dartz.dart';
import 'package:rizqmart/core/error/failures.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/user_profile_repository.dart';

class GetUserProfileUsecase {
  final UserProfileRepository repository;
  const GetUserProfileUsecase(this.repository);
  Future<Either<Failure, UserProfileEntities>> call(String userId) async {
    return await repository.getUserProfile(userId);
  }
}