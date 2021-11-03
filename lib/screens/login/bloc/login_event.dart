part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SignInTappedEvent extends LoginEvent {}

class SignInDoNotHaveAccountEvent extends LoginEvent {}

class SignUpTappedEvent extends LoginEvent {
  final User user;
  final String name;
  final String email;

  SignUpTappedEvent({
    @required this.user,
    @required this.name,
    @required this.email,
  });
}

class SignUpAlreadyHaveAccountEvent extends LoginEvent {}
