import 'package:flutter/material.dart';

class EditAccountTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String placeHolder;

  const EditAccountTextField({
    @required this.controller,
    this.obscureText = false,
    @required this.placeHolder,
  });

  @override
  _SettingsTextFieldState createState() => _SettingsTextFieldState();
}

class _SettingsTextFieldState extends State<EditAccountTextField> {
  final focusNode = FocusNode();
  bool stateObscureText = false;

  @override
  void initState() {
    super.initState();

    stateObscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant EditAccountTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    stateObscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _createSettingsTextField(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createSettingsTextField() {
    return TextField(
      focusNode: focusNode,
      controller: widget.controller,
      obscureText: stateObscureText,
      style: TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: widget.placeHolder,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}
