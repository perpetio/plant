import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/screens/home/view/home_screen.dart';
import 'package:plant/utils/router.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26.0, 65.0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Sign In',
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
                            FocusScope.of(context).unfocus();
                            _formKey.currentState.save();
                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _email, password: _password);
                              if (user != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: HomeScreen()),
                                  ModalRoute.withName(Routers.home),
                                );
                              }
                            } catch (error) {
                              _scaffoldKey.currentState.showSnackBar(
                                new SnackBar(
                                  backgroundColor: Colors.orange,
                                  content: new Text(error.toString()),
                                ),
                              );
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
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account? '),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(Routers.sign_up),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
