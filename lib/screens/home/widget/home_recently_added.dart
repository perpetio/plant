import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/home/widget/home_plant_slider.dart';

class HomeRecentlyAdded extends StatelessWidget {
  final List<PlantsModels> listPlantsModels;
  final Size size;

  const HomeRecentlyAdded({
    @required this.listPlantsModels,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recent added: ',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
              SizedBox(height: 15),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _createPlantImage(),
                      SizedBox(width: 20),
                      _createPlantData(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        HomePlantsSlider(listPlantsModels: listPlantsModels),
        SizedBox(height: size.height * 0.13),
      ],
    );
  }

  Widget _createPlantData() {
    return Expanded(
      child: Text(
        listPlantsModels.last.plantModels.last.plantName,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _createPlantImage() {
    return Container(
      width: 70,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          listPlantsModels.last.plantsImages.last.url ?? "",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
