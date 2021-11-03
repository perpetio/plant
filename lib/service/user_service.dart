import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService {
  static final FirebaseAuth firebase = FirebaseAuth.instance;

  static Future<bool> changeUserEmail(
      {@required String email, @required String password}) async {
    try {
      await firebase.signInWithEmailAndPassword(
          email: firebase.currentUser.email, password: password);
      await firebase.currentUser?.updateEmail(email);
      return true;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<void> changeUserPassword(
      {@required String newPassword, @required String oldPassword}) async {
    try {
      await firebase.signInWithEmailAndPassword(
          email: firebase.currentUser.email, password: oldPassword);
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
