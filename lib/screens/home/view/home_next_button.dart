import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

class HomeNextButton extends StatelessWidget {
  final CarouselController controller;
  const HomeNextButton({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => controller.nextPage(),
      elevation: 7.0,
      fillColor: Colors.orangeAccent,
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 30.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16.0),
      shape: CircleBorder(),
    );
  }
}
