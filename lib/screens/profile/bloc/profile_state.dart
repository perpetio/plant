part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

// class ProfileReloadImageState extends ProfileState {
//   final String photoURL;

//   ProfileReloadImageState({@required this.photoURL});
// }

// class ProfileReloadUserDataState extends ProfileState {
//   final String displayName;
//   final String email;

//   ProfileReloadUserDataState({
//     @required this.displayName,
//     @required this.email,
//   });
// }
