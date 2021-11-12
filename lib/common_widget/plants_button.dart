import 'package:flutter/material.dart';
import 'package:plant/const/color_const.dart';

class PlantButton extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final Function() onTap;

  PlantButton({
    @required this.title,
    this.isEnabled = true,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: isEnabled ? ColorConstants.green : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorConstants.green, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isEnabled ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
