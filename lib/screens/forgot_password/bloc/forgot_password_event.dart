part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class ForgotPassSaveTappedEvent extends ForgotPasswordEvent {
  final String email;

  ForgotPassSaveTappedEvent({
    @required this.email,
  });
}
