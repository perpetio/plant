import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/common_widget/plants_button.dart';
import 'package:plant/injection_container.dart';
import 'package:plant/screens/home/page/home_screen.dart';
import 'package:plant/screens/login/bloc/login_bloc.dart';
import 'package:plant/screens/login/page/sign_up_screen.dart';
import 'package:plant/screens/login/widget/login_text_field.dart';
import 'package:plant/service/auth_service.dart';
import 'package:plant/service/validation_service.dart';
import 'package:plant/utils/router.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    final LoginBloc bloc = serviceLocator.get<LoginBloc>();
    return BlocProvider<LoginBloc>(
      create: (_) => bloc,
      child: BlocConsumer<LoginBloc, LoginState>(
        buildWhen: (_, currState) => currState is LoginInitial,
        builder: (context, state) {
          // final bloc = BlocProvider.of<LoginBloc>(context);

          return Stack(
            children: [
              _createSignInBackground(context),
              _createUserDataPanel(context, bloc),
            ],
          );
        },
        listenWhen: (_, currState) =>
            currState is SignInTappedState ||
            currState is SignInDoNotHaveAccountState ||
            currState is SignInForgotPasswordState,
        listener: (context, state) {
          if (state is SignInTappedState) {
            Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                  type: PageTransitionType.fade, child: HomeScreen()),
              ModalRoute.withName(Routers.home),
            );
          } else if (state is SignInDoNotHaveAccountState) {
            Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                  type: PageTransitionType.fade, child: SignUpScreen()),
              ModalRoute.withName(Routers.sign_up),
            );
          } else if (state is SignInForgotPasswordState) {
            Navigator.pushNamed(context, Routers.forgot_password);
          }
        },
      ),
    );
  }

  Widget _createSignInBackground(BuildContext context) {
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
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Sign In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createUserDataPanel(BuildContext context, LoginBloc bloc) {
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
                validator: (password) {
                  if (ValidationService.password(password))
                    return null;
                  else
                    return 'Password should contain at least 6 characters';
                },
              ),
              SizedBox(height: 40),
              _createSignInButton(context, bloc),
              SizedBox(height: 10),
              _createForgotPassword(bloc),
              SizedBox(height: 10),
              _createDoNotHaveAccount(bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSignInButton(BuildContext context, LoginBloc bloc) {
    return PlantButton(
      title: 'Sign In',
      onTap: () async {
        FocusScope.of(context).unfocus();
        try {
          final user = await AuthService.signIn(
              emailController.text, passwordController.text);
          if (user != null) {
            bloc.add(SignInTappedEvent());
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

  Widget _createForgotPassword(LoginBloc bloc) {
    return TextButton(
        onPressed: () {
          bloc.add(SignInForgotPasswordEvent());
        },
        child: Text(
          'Forgot password?',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget _createDoNotHaveAccount(LoginBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: TextStyle(fontSize: 15),
        ),
        InkWell(
          onTap: () => bloc.add(SignInDoNotHaveAccountEvent()),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
