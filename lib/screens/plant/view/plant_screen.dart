import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plant/api/trefle_api.dart';
import 'package:plant/widgets/screen_template.dart';

class PlantScreen extends StatelessWidget {
  final String name;
  final File image;

  const PlantScreen({Key key, this.name, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      isAppBar: false,
      index: 0,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(child: BackButton()),
            ),
            FutureBuilder(
              future: getPlant(plant: name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Text('Yes');
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
