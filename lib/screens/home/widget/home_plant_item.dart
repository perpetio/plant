import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/core/service/modal_service.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/scan/bloc/scan_bloc.dart';

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
        child: Hero(
          tag: 'panel$imageUrl',
          child: Material(
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
        ),
      ),
    );
  }

  Widget _createBackgroundImage(String image) {
    return Container(
      child: Image.network(
        plantsModels.plantsImages[0].url,
        fit: BoxFit.cover,
        width: 1000,
        height: 1000,
      ),
    );
  }

  Widget _createDeleteItem(BuildContext context, HomeBloc bloc) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: Icon(Icons.more_horiz),
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 30,
          child: InkWell(
            child: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.red),
                SizedBox(width: 5),
                Text(
                  'Delete plant',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                )
              ],
            ),
            onTap: () => ModalService.showCustomAlertDialog(
              context,
              image1: Image.asset(
                'assets/images/deleteEmoji.png',
                width: 32,
                height: 32,
              ),
              image2: Image.asset('assets/images/plant.png'),
              title: 'Delete plant',
              description:
                  'Are you sure you want to delete ${plantsModels.plantModels[0].plantName} plant?',
              agreementButton: 'Yes, delete',
              onTapAgreement: () =>
                  bloc.add(DeletePlantItemEvent(plant: plantsModels)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _createMainInfo(BuildContext context, String imageUrl) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.75,
      height: size.height * 0.2,
      color: Color.fromRGBO(255, 255, 255, 0.97),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, left: 10, right: 30, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                plantsModels.plantModels[0].plantName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              plantsModels.plantModels[0].plantDetails.wikiDescription.value,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
