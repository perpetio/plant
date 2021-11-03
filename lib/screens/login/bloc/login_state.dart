part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class SignInTappedState extends LoginState {}

class SignInDoNotHaveAccountState extends LoginState {}

class SignUpTappedState extends LoginState {}

class SignUpAlreadyHaveAccountState extends LoginState {}
