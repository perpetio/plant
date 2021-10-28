import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant/screens/home/view/home_screen.dart';
import 'package:plant/screens/login/view/sign_in_screen.dart';

class Authentication extends StatelessWidget {
  static final User firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (firebaseUser != null) {
      return HomeScreen();
    } else {
      return SignInScreen();
    }
  }
}
