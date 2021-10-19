import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';

class PlantDetailsPanel extends StatelessWidget {
  final PlantModel plantModel;

  PlantDetailsPanel({
    @required this.plantModel,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _createPlantDetails(),
                const SizedBox(height: 15),
                _plantDetails('Description: ',
                    plantModel.plantDetails.wikiDescription.value),
                const SizedBox(height: 15),
                _plantDetails('Wiki url for more details: ',
                    plantModel.plantDetails.wikiDescription.citation),
                const SizedBox(height: 15),
                _plantDetails('Common names: ',
                    '${plantModel.plantDetails.commonNames.join('')}'),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPlantDetails() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Plant Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 5,
          child: Image.asset('assets/images/slider_line.png'),
        )
      ],
    );
  }

  Widget _plantDetails(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
