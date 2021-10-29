import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService {
  static final FirebaseAuth firebase = FirebaseAuth.instance;

  static Future<UserCredential> reauthenticateWithCredential(
      String email, String password) async {
    User firebaseUser = firebase.currentUser;
    UserCredential result = await firebaseUser.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    return result;
  }

  static Future<bool> changeUserEmail({@required String email}) async {
    reauthenticateWithCredential(firebase.currentUser.email, 'qweqwe');
    try {
      await firebase.currentUser?.updateEmail(email);
      return true;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<bool> changeUserPassword({@required String newPassword}) async {
    reauthenticateWithCredential(firebase.currentUser.email, 'qweqwe');
    try {
      await firebase.currentUser?.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> signOut() async {
    await firebase.signOut();
  }
}
