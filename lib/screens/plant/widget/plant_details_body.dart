import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';

class PlantDetailsBody extends StatelessWidget {
  final String image;
  final PlantModel plantModel;

  PlantDetailsBody({
    @required this.image,
    @required this.plantModel,
  });

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
          _createDetails(),
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
      left: 16,
      top: 25,
      child: GestureDetector(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
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

  Widget _createDetails() {
    return Positioned(
      top: 50,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _createPlantDescription(
              'Family: ', plantModel.plantDetails.taxonomy.family),
          const SizedBox(height: 5),
          _createPlantDescription(
              'Genus: ', plantModel.plantDetails.taxonomy.genus),
          const SizedBox(height: 5),
          _createPlantDescription(
              'Class: ', plantModel.plantDetails.taxonomy.tClass),
        ],
      ),
    );
  }

  Widget _createPlantDescription(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Text(description,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
