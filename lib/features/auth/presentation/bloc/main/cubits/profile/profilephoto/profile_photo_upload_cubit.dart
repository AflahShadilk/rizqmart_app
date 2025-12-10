import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePhotoUploadCubit extends Cubit<bool> {
  ProfilePhotoUploadCubit() : super(false);

  void startUploading() => emit(true);

  void stopUploading() => emit(false);
}
