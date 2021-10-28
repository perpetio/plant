part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class EditProfileInitialEvent extends EditProfileEvent {}

class EditProfileChangeImageEvent extends EditProfileEvent {}

class EditProfileTakeImageEvent extends EditProfileEvent {}

class EditProfileChangeDataEvent extends EditProfileEvent {
  final TextEditingController nameController;
  final TextEditingController emailController;

  EditProfileChangeDataEvent({
    @required this.nameController,
    @required this.emailController,
  });
}

class EditProfileReloadImageEvent extends EditProfileEvent {
  final String userImage;

  EditProfileReloadImageEvent({
    @required this.userImage,
  });
}
