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

    try {
      final profile = await getUserProfileUsecase.call(event.userId);
      emit(UserProfileLoadedState(profile: profile));
    } catch (e) {
      emit(UserProfileErrorState(message: e.toString()));
    }
  }

  Future<void> onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoadingState());

    try {
      final updatedProfile = await updateProfileUsecase.call(event.profile);
      emit(UserProfileLoadedState(profile: updatedProfile));
    } catch (e) {
      emit(UserProfileErrorState(message: e.toString()));
    }
  }

  Future<void> onUploadProfilePhoto(
    UploadProfilePhotoEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    

    try {
      final photoUrl = await uploadProfilePhotoUsecase.call(event.userId, event.file);
      emit(UserProfilePhotoUploadedState(photoUrl: photoUrl));
      
      
    } catch (e) {
      emit(UserProfileErrorState(message: e.toString()));
    }
  }

  Future<void> onDeleteProfilePhoto(
    DeleteProfilePhotoEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoadingState());

    try {
      await deleteProfilePhotoUsecase.call(event.userId);
      
      add(LoadUserProfileEvent(userId: event.userId));
    } catch (e) {
      emit(UserProfileErrorState(message: e.toString()));
    }
  }
}