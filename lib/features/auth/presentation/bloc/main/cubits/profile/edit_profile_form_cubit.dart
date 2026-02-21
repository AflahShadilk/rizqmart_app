import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/profile/edit_profile_form_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_state.dart';

class EditProfileFormCubit extends Cubit<EditProfileFormState> {
  final UserProfileBloc profileBloc;

  EditProfileFormCubit({required this.profileBloc})
      : super(const EditProfileFormInitial());

  void saveProfile({
    required String name,
    required String email,
    required String phone,
    required String bio,
    required DateTime? dateOfBirth,
    required String? gender,
  }) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      emit(const EditProfileFormError('Error: User not authenticated'));
      return;
    }

    final userId = currentUser.uid;

    if (userId.isEmpty) {
      emit(const EditProfileFormError('Error: User ID is missing'));
      return;
    }

    String? photoUrl;
    if (profileBloc.state is UserProfileLoadedState) {
      photoUrl = (profileBloc.state as UserProfileLoadedState).profile.photoUrl;
    }

    final updatedProfile = UserProfileEntities(
      userId: userId,
      name: name,
      email: email,
      phoneNumber: phone.isEmpty ? null : phone,
      photoUrl: photoUrl,
      bio: bio.isEmpty ? null : bio,
      dateOfBirth: dateOfBirth,
      gender: gender,
      updatedAt: DateTime.now(),
    );

    profileBloc.add(UpdateUserProfileEvent(profile: updatedProfile));
    emit(const EditProfileFormSuccess());
  }
}
