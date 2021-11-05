import 'package:flutter/material.dart';
import 'package:plant/models/plant_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantDetailsPanel extends StatelessWidget {
  final PlantModel plantModel;

  PlantDetailsPanel({
    @required this.plantModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _createPlantDetails(),
                const SizedBox(height: 15),
                _plantDetails('Description: ',
                    plantModel.plantDetails.wikiDescription.value),
                const SizedBox(height: 15),
                _createWikiUrl(),
                const SizedBox(height: 15),
                _plantDetails('Common names: ',
                    plantModel.plantDetails.commonNames.join(', ')),
                const SizedBox(height: 15),
                _plantDetails(
                    'Synonyms: ', plantModel.plantDetails.synonyms.join(', ')),
                const SizedBox(height: 15),
                plantModel.plantDetails.wikiImages != null ||
                        plantModel.plantDetails.wikiImages != []
                    ? _createPlantsImages()
                    : Container(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPlantDetails() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Plant Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 5,
          child: Image.asset('assets/images/slider_line.png'),
        )
      ],
    );
  }

  Widget _plantDetails(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _createWikiUrl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wiki url for more details: ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        InkWell(
          child: Text(
            plantModel.plantDetails.wikiDescription.citation,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),
          ),
          onTap: () async {
            final url = plantModel.plantDetails.wikiDescription.citation;
            if (await launch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
      ],
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
