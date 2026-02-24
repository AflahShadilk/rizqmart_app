import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/userprofile/delete_profile_photo_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/userprofile/get_user_profile_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/userprofile/update_profile_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/userprofile/upload_profile_photo_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUsecase getUserProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;
  final UploadProfilePhotoUsecase uploadProfilePhotoUsecase;
  final DeleteProfilePhotoUsecase deleteProfilePhotoUsecase;
  
  UserProfileBloc({required this.getUserProfileUsecase,
  required this.uploadProfilePhotoUsecase,
  required this.updateProfileUsecase,
  required this.deleteProfilePhotoUsecase
  }) : super(UserProfileInitialState()) {
    on<LoadUserProfileEvent>(onLoadUserProfile);
    on<UpdateUserProfileEvent>(onUpdateUserProfile);
    on<UploadProfilePhotoEvent>(onUploadProfilePhoto);
    on<DeleteProfilePhotoEvent>(onDeleteProfilePhoto);
  }

  Future<void> onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoadingState());

    final result = await getUserProfileUsecase.call(event.userId);
    result.fold(
      (failure) => emit(UserProfileErrorState(message: failure.message)),
      (profile) => emit(UserProfileLoadedState(profile: profile)),
    );
  }

  Future<void> onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoadingState());

    final result = await updateProfileUsecase.call(event.profile);
    result.fold(
      (failure) => emit(UserProfileErrorState(message: failure.message)),
      (updatedProfile) => emit(UserProfileLoadedState(profile: updatedProfile)),
    );
  }

  Future<void> onUploadProfilePhoto(
    UploadProfilePhotoEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    final result = await uploadProfilePhotoUsecase.call(event.userId, event.file);
    result.fold(
      (failure) => emit(UserProfileErrorState(message: failure.message)),
      (photoUrl) => emit(UserProfilePhotoUploadedState(photoUrl: photoUrl)),
    );
  }

  Future<void> onDeleteProfilePhoto(
    DeleteProfilePhotoEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoadingState());

    final result = await deleteProfilePhotoUsecase.call(event.userId);
    result.fold(
      (failure) => emit(UserProfileErrorState(message: failure.message)),
      (_) {
        add(LoadUserProfileEvent(userId: event.userId));
      },
    );
  }
}