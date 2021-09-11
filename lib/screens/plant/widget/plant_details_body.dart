import 'package:flutter/material.dart';

class PlantDetailsBody extends StatelessWidget {
  final String image;

  PlantDetailsBody({@required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          _createImage(),
          _createBackButton(context),
        ],
      ),
    );
  }

  Widget _createImage() {
    return Container(
      width: double.infinity,
      child: Image(
        image: NetworkImage(image),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _createBackButton(BuildContext context) {
    return Positioned(
      left: 25,
      child: GestureDetector(
        child: SafeArea(
          child: Container(
            width: 30,
            height: 30,
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 30.0,
              color: Colors.black,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
