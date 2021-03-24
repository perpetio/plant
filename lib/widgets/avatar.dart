import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String assetName;
  const Avatar({Key key, this.assetName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CircleAvatar(
        backgroundImage: AssetImage(assetName),
      ),
    );
  }
}
