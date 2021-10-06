import 'package:flutter/material.dart';
import 'package:plant/models/plant_net.dart';
import 'package:plant/utils/router.dart';

class HomePlantItem extends StatelessWidget {
  final PlantDetect plant;

  const HomePlantItem({Key key, this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routers.plant,
          arguments: plant,
        );
      },
      child: Padding(
        padding:
            EdgeInsets.only(left: 4.0, right: 4.0, bottom: 20.0, top: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 7,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            child: Stack(
              children: [
                Container(
                  child: Image.network(
                    plant.image,
                    fit: BoxFit.cover,
                    width: 1000.0,
                    height: 1000.0,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: buildMainInfo(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMainInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.25,
      color: Color.fromRGBO(255, 255, 255, 0.97),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 40, bottom: 60, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                plant.species.scientificNameWithoutAuthor,
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1.0,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              plant.score.toStringAsFixed(2),
              style: TextStyle(
                  color: Colors.black, letterSpacing: 1.0, fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
