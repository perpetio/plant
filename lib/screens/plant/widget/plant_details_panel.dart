import 'package:flutter/material.dart';
import 'package:plant/models/plant_net.dart';

class PlantDetailsPanel extends StatelessWidget {
  final PlantDetect plantDetect;

  PlantDetailsPanel({@required this.plantDetect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        _createPlantTitle(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createPlantDetails(),
              _createFamily(),
              _createOrigin(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createPlantTitle() {
    return Text(
      '${plantDetect.species.scientificNameWithoutAuthor}',
      style: TextStyle(
        fontSize: 28,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _createPlantDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Plant Details',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _createFamily() {
    return Text('Family');
  }

  Widget _createOrigin() {
    return Text('Origin');
  }
}
