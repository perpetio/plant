import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SignInTappedEvent) {
      yield SignInTappedState();
    } else if (event is SignInDoNotHaveAccountEvent) {
      yield SignInDoNotHaveAccountState();
    } else if (event is SignUpTappedEvent) {
      _createFirebaseUser(event.user, event.name, event.email);
      yield SignUpTappedState();
    } else if (event is SignInForgotPasswordEvent) {
      yield SignInForgotPasswordState();
    } else if (event is SignUpAlreadyHaveAccountEvent) {
      yield SignUpAlreadyHaveAccountState();
    }
  }

  _createFirebaseUser(User newUser, String name, String email) {
    FirebaseFirestore.instance.collection("users").doc(newUser.uid).set({
      "uid": newUser.uid,
      "name": name,
      "email": email,
      "image": '',
    });
  }
}
