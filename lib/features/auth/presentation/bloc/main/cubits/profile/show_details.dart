import 'package:flutter_bloc/flutter_bloc.dart';
class UserDetailsEditCubit extends Cubit<bool> {
  UserDetailsEditCubit() : super(false);

  void toggleEditMode() => emit(!state);
  void setEditMode(bool isEditing) => emit(isEditing);
}