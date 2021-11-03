part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SignInTappedEvent extends LoginEvent {}

class SignInDoNotHaveAccountEvent extends LoginEvent {}
