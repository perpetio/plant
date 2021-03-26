import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/screens/home/view/home_screen.dart';
import 'package:plant/screens/login/view/sign_in_screen.dart';
import 'package:plant/utils/router.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26.0, 50.0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 25.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sign Up Here',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 6,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36.0, 56.0, 26.0, 36.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          onSaved: (emailValue) {
                            _email = emailValue;
                          },
                          style: TextStyle(color: Colors.grey),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            errorStyle: TextStyle(color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle: TextStyle(color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          obscureText: true,
                          onSaved: (passValue) {
                            _password = passValue;
                          },
                          style: TextStyle(color: Colors.grey),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            errorStyle: TextStyle(color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle: TextStyle(color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey,
                            )),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        InkWell(
                          onTap: () async {
                            _formKey.currentState.save();
                            try {
                              final new_user =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _email, password: _password);
                              print(_email);
                              print(_password);
                              if (new_user != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: HomeScreen()),
                                  ModalRoute.withName(Routers.home),
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
