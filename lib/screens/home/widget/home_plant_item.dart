import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/scan/bloc/scan_bloc.dart';
import 'package:plant/service/modal_service.dart';

class HomePlantItem extends StatelessWidget {
  final PlantsModels plantsModels;

  HomePlantItem({
    @required this.plantsModels,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    final String imageUrl = plantsModels.plantsImages[0].url;
    return GestureDetector(
      onTap: () {
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
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: BlocProvider(
              create: (context) => ScanBloc(),
              child: Stack(
                children: [
                  _createBackgroundImage(imageUrl),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _createDeleteItem(context, bloc),
                  ),
                  Positioned(
                    bottom: 0,
                    child: _createMainInfo(context, imageUrl),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createBackgroundImage(String image) {
    return Container(
      child: Hero(
        tag: 'image$image',
        child: Image.network(
          plantsModels.plantsImages[0].url,
          fit: BoxFit.cover,
          width: 1000,
          height: 1000,
        ),
      ),
    );
  }

  Widget _createDeleteItem(BuildContext context, HomeBloc bloc) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Icon(
          Icons.delete_outline,
          size: 35,
          color: Colors.red,
        ),
      ),
      onTap: () => ModalService.showAlertDialog(
        context,
        description: 'Delete the plant?',
        onTap: () => bloc.add(DeletePlantItemEvent(plant: plantsModels)),
      ),
    );
  }

  Widget _createMainInfo(BuildContext context, String imageUrl) {
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
              child: Hero(
                tag: 'text$imageUrl',
                child: Container(
                  width: size.width * 0.6,
                  child: Material(
                    child: Text(
                      plantsModels.plantModels[0].plantName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
