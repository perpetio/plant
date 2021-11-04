import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/scan/bloc/scan_bloc.dart';

class HomePlantItem extends StatelessWidget {
  final PlantsModels plantsModels;

  const HomePlantItem({
    Key key,
    @required this.plantsModels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<HomeBloc>(context);
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(_createRoute());
        bloc.add(OpenPlantDetailEvent(plant: plantsModels));
      },
      child: Padding(
        padding: EdgeInsets.only(left: 4, right: 4, bottom: 20, top: 10),
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: BlocProvider(
              create: (context) => ScanBloc(),
              child: Stack(
                children: [
                  Container(
                    child: Image.network(
                      plantsModels.plantsImages[0].url,
                      fit: BoxFit.cover,
                      width: 1000,
                      height: 1000,
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                width: size.width * 0.6,
                child: Text(
                  plantsModels.plantModels[0].plantName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
