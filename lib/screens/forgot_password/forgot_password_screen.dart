import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/common_widget/plants_button.dart';
import 'package:plant/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:plant/screens/login/widget/login_text_field.dart';
import 'package:plant/service/validation_service.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(context),
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  BlocProvider<ForgotPasswordBloc> _buildBody(BuildContext context) {
    return BlocProvider<ForgotPasswordBloc>(
      create: (BuildContext context) => ForgotPasswordBloc(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        buildWhen: (_, currState) =>
            currState is ForgotPasswordInitial ||
            currState is ForgotPassErrorState ||
            currState is ForgotPassSuccessState,
        builder: (context, state) {
          final bloc = BlocProvider.of<ForgotPasswordBloc>(context);
          if (state is ForgotPassSuccessState) {
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.orange,
                content: Text(state.message),
                duration: Duration(seconds: 3)));
          } else if (state is ForgotPassErrorState) {
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.orange,
                content: Text(state.error),
                duration: Duration(seconds: 3)));
          }
          return _buildContent(context, bloc);
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }

  Widget _buildContent(BuildContext context, ForgotPasswordBloc bloc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
      child: Form(
        key: _formKey,
        child: Column(
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
                  return 'Enter a valid email';
              },
            ),
            SizedBox(height: 40),
            PlantButton(
              title: 'Save',
              onTap: () {
                if (_formKey.currentState.validate())
                  bloc.add(
                      ForgotPassSaveTappedEvent(email: emailController.text));
              },
            ),
          ],
        ),
      ),
    );
  }
}
