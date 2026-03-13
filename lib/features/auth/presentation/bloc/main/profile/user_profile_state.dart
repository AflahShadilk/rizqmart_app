import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitialState extends UserProfileState {}

class UserProfileLoadingState extends UserProfileState {}

class UserProfileLoadedState extends UserProfileState {
  final UserProfileEntities profile;

  const UserProfileLoadedState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class UserProfilePhotoUploadingState extends UserProfileState {}

class UserProfilePhotoUploadedState extends UserProfileState {
  final String photoUrl;

  const UserProfilePhotoUploadedState({required this.photoUrl});

  @override
  List<Object?> get props => [photoUrl];
}

class UserProfileErrorState extends UserProfileState {
  final String message;

  const UserProfileErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
