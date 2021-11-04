part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPassErrorState extends ForgotPasswordState {
  final String error;

  ForgotPassErrorState({
    @required this.error,
  });
}

class ForgotPassSuccessState extends ForgotPasswordState {
  final String message;

  ForgotPassSuccessState({
    @required this.message,
  });
}
