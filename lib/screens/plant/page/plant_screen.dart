import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/plant/bloc/plant_bloc.dart';
import 'package:plant/screens/plant/widget/plant_details_content.dart';
import 'package:plant/common_widget/screen_template.dart';

class PlantScreen extends StatelessWidget {
  final PlantsModels plantsModels;

  const PlantScreen({
    this.plantsModels,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlantBloc>(
      create: (_) => PlantBloc(),
      child: BlocConsumer<PlantBloc, PlantState>(
        listener: (context, state) {},
        listenWhen: (_, currState) => true,
        buildWhen: (_, currState) =>
            currState is PlantInitial || currState is PlantBackTappedState,
        builder: (context, state) {
          if (state is PlantBackTappedState) {
            Navigator.of(context).pop();
          }
          return ScreenTemplate(
            isAppBar: false,
            index: 0,
            body: Container(
              color: Colors.white,
              child: _createPlantDetails(context),
            ),
          );
        },
      ),
    );
  }

  Widget _createPlantDetails(BuildContext context) {
    return Hero(
      tag: 'panel${plantsModels.plantsImages[0].url}',
      child: Material(
        child: PlantDetailsContent(
          image: plantsModels.plantsImages[0].url,
          plantModel: plantsModels.plantModels[0],
        ),
        // SlidingUpPanel(
        //   header: _createHeader(context),
        //   panel: PlantDetailsPanel(
        //     plantModel: plantsModels.plantModels[0],
        //     image: plantsModels.plantsImages[0].url,
        //   ),
        //   body: PlantDetailsBody(
        //     image: plantsModels.plantsImages[0].url ?? '',
        //     plantModel: plantsModels.plantModels[0],
        //   ),
        //   minHeight: MediaQuery.of(context).size.height * 0.65,
        //   maxHeight: MediaQuery.of(context).size.height * 0.95,
        //   isDraggable: true,
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(55),
        //     topRight: Radius.circular(55),
        //   ),
        // ),
      ),
    );
  }

  // Widget _createHeader(BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     margin: const EdgeInsets.only(top: 15),
  //     child: Center(
  //       child: Text(
  //         plantsModels.plantModels[0].plantName,
  //         style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //       ),
  //     ),
  //   );
  // }
}
