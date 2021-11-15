import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/const/color_const.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/plant/bloc/plant_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantDetailsContent extends StatelessWidget {
  final String image;
  final PlantModel plantModel;

  PlantDetailsContent({
    @required this.image,
    @required this.plantModel,
  });
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PlantBloc>(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          _createImagePlant(context, bloc),
          SizedBox(height: 30),
          _createTitle(context),
          SizedBox(height: 16),
          _createDetails(),
          SizedBox(height: 24),
          _createPlantDetails(
              'About: ', plantModel.plantDetails.wikiDescription.value),
          const SizedBox(height: 15),
          _createWikiUrl(),
          const SizedBox(height: 15),
          _createPlantDetails(
              'Common names: ', plantModel.plantDetails.commonNames.join(', ')),
          const SizedBox(height: 15),
          _createPlantDetails(
              'Synonyms: ', plantModel.plantDetails.synonyms.join(', ')),
          const SizedBox(height: 15),
          plantModel.plantDetails.wikiImages != null ||
                  plantModel.plantDetails.wikiImages != []
              ? _createPlantsImages()
              : Container(),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  Widget _createImagePlant(BuildContext context, PlantBloc bloc) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 280,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image(image: NetworkImage(image), fit: BoxFit.cover)),
        ),
        _createBackButton(bloc),
      ],
    );
  }

  Widget _createBackButton(PlantBloc bloc) {
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 7,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Icon(Icons.arrow_back, size: 30, color: Colors.black),
          ),
        ),
        onTap: () {
          bloc.add(PlantBackTappedEvent());
        },
      ),
    );
  }

  Widget _createTitle(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 15),
      child: Center(
        child: Text(
          plantModel.plantName,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _createDetails() {
    return Wrap(
      spacing: 8,
      runSpacing: 16,
      children: [
        _createPlantDescription(
            'Family: ', plantModel.plantDetails.taxonomy.family),
        const SizedBox(width: 5),
        _createPlantDescription(
            'Genus: ', plantModel.plantDetails.taxonomy.genus),
        const SizedBox(width: 5),
        _createPlantDescription(
            'Class: ', plantModel.plantDetails.taxonomy.tClass),
      ],
    );
  }

  Widget _createPlantDescription(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 7,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ColorConstants.green,
              ),
            ),
            TextSpan(
              text: description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createPlantDetails(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _createWikiUrl() {
    return InkWell(
      child: Container(
        width: 60,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24)),
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
            Image.network(
              'assets/icons/link.png',
              color: ColorConstants.green,
              fit: BoxFit.cover,
              width: 24,
              height: 24,
            ),
            SizedBox(width: 5),
            Text(
              "Wikipedia link",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ColorConstants.green,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        final url = plantModel.plantDetails.wikiDescription.citation;
        if (await launch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }

  Widget _createPlantsImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Common Images: ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: plantModel.plantDetails.wikiImages.length,
            itemBuilder: (context, index) {
              return _createImage(plantModel.plantDetails.wikiImages[index]);
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: Colors.grey),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _createImage(WikiImage image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(33),
      child: Image.network(
        image.value,
        fit: BoxFit.cover,
        width: 200,
        height: 100,
      ),
    );
  }
}
