import 'package:flutter/material.dart';
import 'package:plant/models/plant_net.dart';
import 'package:plant/screens/plant/widget/plant_details_body.dart';
import 'package:plant/screens/plant/widget/plant_details_panel.dart';
import 'package:plant/widgets/screen_template.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PlantScreen extends StatelessWidget {
  final PlantDetect plantDetect;

  const PlantScreen({
    @required this.plantDetect,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      isAppBar: false,
      index: 0,
      body: Container(
        color: Colors.white,
        child: _createPlantDetails(context),
      ),
    );
  }

  Widget _createPlantDetails(BuildContext context) {
    return SlidingUpPanel(
      color: Colors.white,
      panel: PlantDetailsPanel(plantDetect: plantDetect),
      body: PlantDetailsBody(image: plantDetect.image ?? ''),
      minHeight: MediaQuery.of(context).size.height * 0.65,
      isDraggable: false,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(55),
        topRight: Radius.circular(55),
      ),
    );
  }
}
