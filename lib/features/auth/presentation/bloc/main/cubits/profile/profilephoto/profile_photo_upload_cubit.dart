import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit handling the boolean state representing an ongoing photo upload.
class ProfilePhotoUploadCubit extends Cubit<bool> {
  ProfilePhotoUploadCubit() : super(false);

  void startUploading() => emit(true);

  void stopUploading() => emit(false);
}
