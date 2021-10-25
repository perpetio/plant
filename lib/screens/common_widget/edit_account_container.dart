import 'package:flutter/material.dart';

class EditAccountContainer extends StatelessWidget {
  final bool withArrow;
  final Widget child;
  final Function() onTap;

  EditAccountContainer(
      {this.withArrow = false, @required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: child),
                  if (withArrow)
                    Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20)
                ],
              ),
            ),
          ),
        ),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 5.0,
                spreadRadius: 1.1)
          ],
        ),
      ),
    );
  }
}
