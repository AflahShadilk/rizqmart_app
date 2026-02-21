import 'package:equatable/equatable.dart';

abstract class EditProfileFormState extends Equatable {
  const EditProfileFormState();

  @override
  List<Object?> get props => [];
}

class EditProfileFormInitial extends EditProfileFormState {
  const EditProfileFormInitial();
}

class EditProfileFormSubmitting extends EditProfileFormState {
  const EditProfileFormSubmitting();
}

class EditProfileFormSuccess extends EditProfileFormState {
  const EditProfileFormSuccess();
}

class EditProfileFormError extends EditProfileFormState {
  final String message;
  const EditProfileFormError(this.message);

  @override
  List<Object?> get props => [message];
}
