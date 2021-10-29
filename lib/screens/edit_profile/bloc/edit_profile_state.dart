part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileProgress extends EditProfileState {}

class EditProfileErrorState extends EditProfileState {
  final String message;

  EditProfileErrorState({
    @required this.message,
  });
}

class EditProfileReloadImageState extends EditProfileState {
  final String userImage;

  EditProfileReloadImageState({
    @required this.userImage,
  });
}

class EditProfileShowErrorState extends EditProfileState {}

class EditProfileSuccessState extends EditProfileState {
  final String message;

  EditProfileSuccessState({
    @required this.message,
  });
}
