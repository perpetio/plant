part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class ChangePasswordSaveTappedEvent extends ChangePasswordEvent {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  ChangePasswordSaveTappedEvent({
    @required this.oldPasswordController,
    @required this.newPasswordController,
    @required this.confirmPasswordController,
  });
}
