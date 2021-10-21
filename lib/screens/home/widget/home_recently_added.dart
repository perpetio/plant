import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/home/widget/home_plant_slider.dart';

class HomeRecentlyAdded extends StatelessWidget {
  final List<PlantsModels> listPlantsModels;
  // final PlantsModels plantsModels;
  final Size size;

  const HomeRecentlyAdded({
    @required this.listPlantsModels,
    // @required this.plantsModels,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 7,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              _createPlantData(),
              Spacer(),
              _createPlantImage(),
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
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recently added:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            ),
            SizedBox(height: 10.0),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    listPlantsModels.last.plantModels.last.plantName,
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                SizedBox(height: 4.0),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createPlantImage() {
    return Expanded(
      flex: 3,
      child: Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            listPlantsModels.last.plantsImages.last.url ?? "",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
