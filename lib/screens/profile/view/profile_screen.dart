import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/screens/login/view/sign_in_screen.dart';
import 'package:plant/screens/profile/bloc/profile_bloc.dart';
import 'package:plant/utils/router.dart';
import 'package:plant/widgets/screen_template.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProfileBloc();
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return ScreenTemplate(
            index: 2,
            title: "Profile",
            body: _Body(),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  _Body({Key key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  PageTransition(
                      type: PageTransitionType.fade, child: SignInScreen()),
                  ModalRoute.withName(Routers.sign_in),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
