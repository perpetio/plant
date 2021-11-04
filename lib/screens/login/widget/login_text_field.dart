import 'package:flutter/material.dart';
import 'package:plant/common_widget/plants_text_field.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String placeHolder;
  final String Function(String) validator;
  final bool obscureText;

  LoginTextField({
    @required this.controller,
    @required this.title,
    @required this.placeHolder,
    @required this.validator,
    @required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 10),
        PlantsTextField(
          placeHolder: placeHolder,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
