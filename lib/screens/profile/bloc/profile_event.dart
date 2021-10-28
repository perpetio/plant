part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileInitialEvent extends ProfileEvent {}

class ProfileReloadImageEvent extends ProfileEvent {}

class ProfileReloadUserDataEvent extends ProfileEvent {}
