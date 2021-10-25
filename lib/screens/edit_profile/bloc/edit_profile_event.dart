part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class EditProfileInitialEvent extends EditProfileEvent {}

class EditProfileChangeImageEvent extends EditProfileEvent {}

class EditProfileChangeDataEvent extends EditProfileEvent {
  final String displayName;
  final String email;

  EditProfileChangeDataEvent({
    @required this.displayName,
    @required this.email,
  });
}
