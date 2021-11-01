import 'package:flutter/material.dart';
import 'package:plant/common_widget/plants_text_field.dart';

// ignore: must_be_immutable
class ConfirmPasswordDialog extends StatelessWidget {
  final Function(String) onSaveTapped;
  TextEditingController passwordController = TextEditingController();

  ConfirmPasswordDialog({
    @required this.onSaveTapped,
    @required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        'Enter your password',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Container(
        height: 100,
        child: PlantsTextField(
          title: 'Password',
          placeHolder: 'Enter your password',
          controller: passwordController,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSaveTapped(passwordController.text);
            Navigator.of(context).pop();
          },
          child: Text('Save', style: TextStyle(fontSize: 15)),
        ),
      ],
    );
  }
}
