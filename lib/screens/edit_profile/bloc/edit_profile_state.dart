part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditAccountProgress extends EditProfileState {}

class EditAccountErrorState extends EditProfileState {
  final String message;

  EditAccountErrorState({
    @required this.message,
  });
}

class EditProfileReloadImageState extends EditProfileState {
  final String userImage;

  EditProfileReloadImageState({
    @required this.userImage,
  });
}
