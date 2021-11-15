import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant/common_widget/plants_button.dart';
import 'package:plant/common_widget/plants_text_field.dart';

class ModalService {
  static void showAlertDialog(
    BuildContext context, {
    @required String description,
    Function() onTap,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          content: Text(
            description,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          actions: [
            CupertinoButton(
              child: Text('OK'),
              onPressed: () {
                onTap();
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  static void showCustomAlertDialog(
    BuildContext context, {
    Image image1,
    Image image2,
    @required String title,
    @required String description,
    @required String agreementButton,
    @required Function() onTapAgreement,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [image1, SizedBox(width: 5), image2],
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            content: Container(
              height: 200,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 32),
                    PlantButton(title: agreementButton, onTap: onTapAgreement),
                    SizedBox(height: 16),
                    PlantButton(
                      title: 'Cancel',
                      onTap: () => Navigator.of(dialogContext).pop(),
                      isEnabled: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
