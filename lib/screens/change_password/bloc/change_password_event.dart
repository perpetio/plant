part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class ChangePasswordSaveTappedEvent extends ChangePasswordEvent {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  ChangePasswordSaveTappedEvent({
    @required this.passwordController,
    @required this.confirmPasswordController,
  });
}
