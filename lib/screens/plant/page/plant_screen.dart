import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/plant/widget/plant_details_body.dart';
import 'package:plant/screens/plant/widget/plant_details_panel.dart';
import 'package:plant/common_widget/screen_template.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PlantScreen extends StatelessWidget {
  final PlantsModels plantsModels;

  const PlantScreen({
    this.plantsModels,
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
      header: _createHeader(context),
      panel: Hero(
        tag: 'panel${plantsModels.plantsImages[0].url}',
        child: Material(
          color: Colors.transparent,
          child: PlantDetailsPanel(
            plantModel: plantsModels.plantModels[0],
            image: plantsModels.plantsImages[0].url,
          ),
        ),
      ),
      body: Hero(
        tag: 'image${plantsModels.plantsImages[0].url}',
        child: PlantDetailsBody(
          image: plantsModels.plantsImages[0].url ?? '',
          plantModel: plantsModels.plantModels[0],
        ),
      ),
      minHeight: MediaQuery.of(context).size.height * 0.65,
      maxHeight: MediaQuery.of(context).size.height * 0.95,
      isDraggable: true,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(55),
        topRight: Radius.circular(55),
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 15),
      child: Center(
        child: Hero(
          tag: 'plantName${plantsModels.plantsImages[0].url}',
          child: Text(
            plantsModels.plantModels[0].plantName,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
