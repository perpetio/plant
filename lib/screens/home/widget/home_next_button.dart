import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:plant/const/color_const.dart';

class HomeNextButton extends StatelessWidget {
  final CarouselController controller;
  const HomeNextButton({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => controller.nextPage(),
      elevation: 7,
      fillColor: ColorConstants.green,
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 30,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }
}
