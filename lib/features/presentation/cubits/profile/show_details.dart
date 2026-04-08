import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit managing the toggle for enabling or disabling edit mode on the profile screen.
class UserDetailsEditCubit extends Cubit<bool> {
  UserDetailsEditCubit() : super(false);

  void toggleEditMode() => emit(!state);
  void setEditMode(bool isEditing) => emit(isEditing);
}