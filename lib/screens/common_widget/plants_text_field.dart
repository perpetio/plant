// class EditAccountTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final bool obscureText;
//   final bool isError;
//   final String placeHolder;
//   final String errorText;
//   final TextInputAction textInputAction;
//   final TextInputType keyboardType;

//   const EditAccountTextField({
//     @required this.controller,
//     this.obscureText = false,
//     this.isError,
//     @required this.placeHolder,
//     this.errorText,
//     this.textInputAction,
//     this.keyboardType,
//   });

//   @override
//   _SettingsTextFieldState createState() => _SettingsTextFieldState();
// }

// class _SettingsTextFieldState extends State<EditAccountTextField> {
//   final focusNode = FocusNode();
//   bool stateObscureText = false;
//   bool stateIsError = false;

//   @override
//   void initState() {
//     super.initState();

//     stateObscureText = widget.obscureText;
//     stateIsError = widget.isError;
//   }

//   @override
//   void didUpdateWidget(covariant EditAccountTextField oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     stateObscureText = widget.obscureText;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _createSettingsTextField(),
//           if (stateIsError) ...[
//             _createError(),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _createSettingsTextField() {
//     return TextField(
//       focusNode: focusNode,
//       controller: widget.controller,
//       obscureText: stateObscureText,
//       textInputAction: widget.textInputAction,
//       keyboardType: widget.keyboardType,
//       style: TextStyle(
//         color: Colors.black,
//         fontSize: 16,
//       ),
//       decoration: InputDecoration(
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: BorderSide(
//             color:
//                 stateIsError ? Colors.red : Colors.grey[100].withOpacity(0.4),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: BorderSide(
//             color: Colors.orange,
//           ),
//         ),
//         hintText: widget.placeHolder,
//         hintStyle: TextStyle(
//           color: Colors.grey,
//           fontSize: 16,
//         ),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }

//   // Widget _createSettingsTextField() {
//   //   return TextField(
//   //     focusNode: focusNode,
//   //     controller: widget.controller,
//   //     obscureText: stateObscureText,
//   //     style: TextStyle(fontWeight: FontWeight.w600),
//   //     decoration: InputDecoration(
//   //       hintText: widget.placeHolder,
//   //       errorText: widget.errorText,
//   //       hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
//   //       border: InputBorder.none,
//   //       focusedBorder: InputBorder.none,
//   //       enabledBorder: InputBorder.none,
//   //       errorBorder: InputBorder.none,
//   //       disabledBorder: InputBorder.none,
//   //     ),
//   //   );
//   // }

//   _createError() {
//     return Container(
//       padding: const EdgeInsets.only(top: 2),
//       child: Text(
//         widget.errorText,
//         style: TextStyle(
//           fontSize: 14,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlantsTextField extends StatefulWidget {
  final String title;
  final String placeHolder;
  final String errorText;
  final bool obscureText;
  final bool isError;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;

  const PlantsTextField({
    @required this.title,
    @required this.placeHolder,
    this.obscureText = false,
    this.isError = false,
    @required this.controller,
    @required this.errorText,
    this.textInputAction = TextInputAction.done,
    this.keyboardType,
  });

  @override
  _PlantsTextFieldState createState() => _PlantsTextFieldState();
}

class _PlantsTextFieldState extends State<PlantsTextField> {
  final focusNode = FocusNode();
  bool stateObscureText = false;
  bool stateIsError = false;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(
      () {
        setState(() {
          if (focusNode.hasFocus) {
            stateIsError = false;
          }
        });
      },
    );

    stateObscureText = widget.obscureText;
    stateIsError = widget.isError;
  }

  @override
  void didUpdateWidget(covariant PlantsTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    stateObscureText = widget.obscureText;
    stateIsError = focusNode.hasFocus ? false : widget.isError;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createHeader(),
          const SizedBox(height: 5),
          _createTextField(),
          if (stateIsError) ...[
            _createError(),
          ],
        ],
      ),
    );
  }

  Widget _createHeader() {
    return Text(
      widget.title,
      style: TextStyle(
        color: _getUserNameColor(),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _getUserNameColor() {
    if (focusNode.hasFocus) {
      return Colors.orange;
    } else if (stateIsError) {
      return Colors.red;
    } else if (widget.controller.text.isNotEmpty) {
      return Colors.black;
    }
    return Colors.grey;
  }

  Widget _createTextField() {
    return TextField(
      focusNode: focusNode,
      controller: widget.controller,
      obscureText: stateObscureText,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: stateIsError ? Colors.red : Colors.black.withOpacity(0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.orange),
        ),
        hintText: widget.placeHolder,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _createError() {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        widget.errorText,
        style: TextStyle(
          fontSize: 12,
          color: Colors.red,
        ),
      ),
    );
  }
}
