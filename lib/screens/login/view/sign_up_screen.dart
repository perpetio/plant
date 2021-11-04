import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/common_widget/plants_button.dart';
import 'package:plant/screens/home/view/home_screen.dart';
import 'package:plant/screens/login/bloc/login_bloc.dart';
import 'package:plant/screens/login/view/sign_in_screen.dart';
import 'package:plant/screens/login/widget/login_text_field.dart';
import 'package:plant/service/auth_service.dart';
import 'package:plant/service/validation_service.dart';
import 'package:plant/utils/router.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(context),
    );
  }

  BlocProvider<LoginBloc> _buildBody(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        buildWhen: (_, currState) => currState is LoginInitial,
        builder: (context, state) {
          final bloc = BlocProvider.of<LoginBloc>(context);

          return Stack(
            children: [
              _createSignUpBackground(context),
              _createAddingUserDataPanel(context, bloc),
            ],
          );
        },
        listenWhen: (_, currState) =>
            currState is SignUpTappedState ||
            currState is SignUpAlreadyHaveAccountState,
        listener: (context, state) {
          if (state is SignUpTappedState) {
            Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                  type: PageTransitionType.fade, child: HomeScreen()),
              ModalRoute.withName(Routers.home),
            );
          } else if (state is SignUpAlreadyHaveAccountState) {
            Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                type: PageTransitionType.fade,
                child: SignInScreen(),
              ),
              ModalRoute.withName(Routers.sign_in),
            );
          }
        },
      ),
    );
  }

  Widget _createSignUpBackground(BuildContext context) {
    return Container(
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
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createAddingUserDataPanel(BuildContext context, LoginBloc bloc) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 5,
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
        child: _createAddingData(context, bloc),
      ),
    );
  }

  Widget _createAddingData(BuildContext context, LoginBloc bloc) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginTextField(
                controller: nameController,
                title: 'Your Name',
                placeHolder: 'Name',
                obscureText: false,
                validator: (name) {
                  if (ValidationService.username(name))
                    return null;
                  else
                    return 'Enter your name';
                },
              ),
              SizedBox(height: 25),
              LoginTextField(
                controller: emailController,
                title: 'Email',
                placeHolder: 'example@gmail.com',
                obscureText: false,
                validator: (email) {
                  if (ValidationService.email(email))
                    return null;
                  else
                    return 'Enter your email';
                },
              ),
              SizedBox(height: 25),
              LoginTextField(
                controller: passwordController,
                title: 'Password',
                placeHolder: 'password',
                obscureText: true,
                validator: (email) {
                  if (ValidationService.email(email))
                    return null;
                  else
                    return 'Email should contain at least 6 characters';
                },
              ),
              SizedBox(height: 40),
              _createSignInButton(context, bloc),
              SizedBox(height: 20),
              _createAlreadyHaveAccount(bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSignInButton(BuildContext context, LoginBloc bloc) {
    return PlantButton(
      title: 'Sign Up',
      onTap: () async {
        FocusScope.of(context).unfocus();
        try {
          final newUser = await AuthService.signUp(
              emailController.text, passwordController.text);
          if (newUser != null) {
            bloc.add(SignUpTappedEvent(
              user: newUser,
              name: nameController.text,
              email: emailController.text,
            ));
          }
        } catch (e) {
          _scaffoldKey.currentState.showSnackBar(
            new SnackBar(
              backgroundColor: Colors.orange,
              content: new Text(e.toString()),
            ),
          );
        }
      },
    );
  }

  Widget _createAlreadyHaveAccount(LoginBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account? '),
        InkWell(
          onTap: () => bloc.add(SignUpAlreadyHaveAccountEvent()),
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
