import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant/common_widget/plants_text_field.dart';

class ModalService {
  static void showAlertDialog(
    BuildContext context, {
    @required String description,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          content: Text(
            description,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          actions: [
            CupertinoButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showPasswordAlertDialog(
    BuildContext context, {
    @required String title,
    @required TextEditingController passwordController,
    @required Function(String) onSaveTapped,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Container(
            height: 100,
            child: PlantsTextField(
              labelText: 'Password',
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
      },
    );
  }
}
