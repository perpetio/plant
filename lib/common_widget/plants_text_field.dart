import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlantsTextField extends StatefulWidget {
  final String placeHolder;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String Function(String) validator;
  final String labelText;

  const PlantsTextField({
    @required this.placeHolder,
    this.obscureText = false,
    @required this.controller,
    this.textInputAction = TextInputAction.done,
    this.keyboardType,
    this.validator,
    this.labelText,
  });

  @override
  _PlantsTextFieldState createState() => _PlantsTextFieldState();
}

class _PlantsTextFieldState extends State<PlantsTextField> {
  final focusNode = FocusNode();
  bool stateObscureText = false;

  @override
  void initState() {
    super.initState();

    stateObscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant PlantsTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    stateObscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: _createTextField(),
    );
  }

  Widget _createTextField() {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.orange),
      child: TextFormField(
        validator: widget.validator,
        focusNode: focusNode,
        controller: widget.controller,
        obscureText: stateObscureText,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          labelText: widget.labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.orange),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
          hintText: widget.placeHolder,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
