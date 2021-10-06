import 'package:flutter/material.dart';
import 'package:plant/models/plant_net.dart';

class PlantDetailsPanel extends StatelessWidget {
  final PlantDetect plantDetect;

  PlantDetailsPanel({@required this.plantDetect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Center(child: _createPlantTitle()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _createPlantDetails(),
              const SizedBox(height: 15),
              _createFamily(),
              const SizedBox(height: 15),
              _createOrigin(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createPlantTitle() {
    return Text(
      plantDetect.species.scientificNameWithoutAuthor,
      style: TextStyle(
        fontSize: 27,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _createPlantDetails() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            'Plant Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 6,
          child: Image.asset('assets/images/slider_line.png'),
        )
      ],
    );
  }

  Widget _createFamily() {
    return Row(
      children: [
        Text('Family: ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(width: 7),
        Text(
          plantDetect.species.family.scientificNameWithoutAuthor,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _createOrigin() {
    return Row(
      children: [
        Text('Origin: ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(width: 7),
        Text('${plantDetect.species.commonNames}'),
      ],
    );
  }
}
