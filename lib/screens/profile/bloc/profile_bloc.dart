import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:plant/utils/authentication.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  Map<String, dynamic> userData;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileInitialEvent) {
      _getData();
      yield ProfileInitial();
    }
    // else if (event is ProfileReloadImageEvent) {
    //   String photoURL = userData['image'] == null || userData['image'] == ''
    //       ? ''
    //       : userData['image'];
    //   yield ProfileReloadImageState(photoURL: photoURL);
    // } else if (event is ProfileReloadUserDataEvent) {
    //   final displayName = userData['name'] == null || userData['name'] == ''
    //       ? ''
    //       : userData['name'];
    //   final userEmail = userData['email'] == null || userData['email'] == ''
    //       ? ''
    //       : userData['email'];
    //   yield ProfileReloadUserDataState(
    //       displayName: displayName, email: userEmail);
    // }
  }

  Future<dynamic> _getData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    userData = snapshot.data();
  }
}
