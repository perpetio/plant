import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';

class HomeSearchPlantsList extends StatelessWidget {
  final List<PlantsModels> plants;

  HomeSearchPlantsList({
    @required this.plants,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: plants.length,
      itemBuilder: (context, index) {
        return _createCell(plants[index]);
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(color: Colors.grey),
        );
      },
    );
  }

  Widget _createCell(PlantsModels plant) {
    final name = plant.plantModels[0].plantName;
    final imageUrl = plant.plantsImages[0].url;
    return InkWell(
      onTap: () {
        print(plant);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(33),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 66,
                height: 66,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
