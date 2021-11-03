part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordProgress extends ChangePasswordState {}

class ChangePasswordErrorState extends ChangePasswordState {
  final String error;
  ChangePasswordErrorState(
    this.error,
  );
}

class ChangePasswordSuccessState extends ChangePasswordState {
  final String message;
  ChangePasswordSuccessState({
    @required this.message,
  });
}

class ChangePasswordShowErrorState extends ChangePasswordState {}
