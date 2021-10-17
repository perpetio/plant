import 'dart:convert';
// import 'dart:developer';
import 'dart:io';
// import 'dart:typed_data';
// import 'package:http/http.dart';
// import 'package:plant/core/settings.dart';
import 'package:plant/models/plant_model.dart';
// import 'package:http/http.dart' as http;

Future<PlantsModels> getPlants(File image) async {
  // final Uint8List bytes = image.readAsBytesSync();
  // final String url = 'https://api.plant.id/v2/identify';

  const String plantJson = '''
  {
    "images": [
      {
      "file_name": "cdc83df78fd24383b0f146669512e0fd.jpg",
      "url": "https://plant.id/media/images/cdc83df78fd24383b0f146669512e0fd.jpg"
      }
    ],
    "suggestions": [
      {
        "id": 190963365,
        "plant_name": "Ficus benjamina",
        "plant_details": {
           "common_names": [
            "Weeping Fig",
            "benjamin fig",
            "ficus tree",
            "ficus"
          ],
          "url": "https://en.wikipedia.org/wiki/Ficus_benjamina",
          "wiki_description": {
          "value": "Ficus benjamina, commonly known as weeping fig, benjamin fig or ficus tree, and often sold in stores as just ficus, is a species of flowering plant in the family Moraceae, native to Asia and Australia. It is the official tree of Bangkok. A recently described variety, Ficus benjamina var. Bracteata is found in uplifted coral forests of southern Taiwan. The species is also naturalized in the West Indies and in the states of Florida and Arizona in the United States. In its native range, its small fruit are favored by some birds, such as the superb fruit dove, wompoo fruit dove, pink-spotted fruit dove, ornate fruit dove, orange-bellied fruit dove, Torresian imperial pigeon, and purple-tailed imperial pigeon."
          },
          "taxonomy": {
            "class": "Magnoliopsida",
            "family": "Moraceae",
            "genus": "Ficus"
          },
          "wiki_images": [
            {
            "value": "https://plant-id.ams3.cdn.digitaloceanspaces.com/plant_id_knowledge_base/ae0/ce129c853db14de868f98ecf047dc.jpg"
            },
            {
             "value": "https://plant-id.ams3.cdn.digitaloceanspaces.com/plant_id_knowledge_base/d04/fe2eadfea54e1d730b4ca333152b9.jpg"
            },
            {
             "value": "https://plant-id.ams3.cdn.digitaloceanspaces.com/plant_id_knowledge_base/c03/ce54b16b6157b31960a32001144e1.jpg"
            }
          ],
          "synonyms": [
            "Ficus benjamina subsp. comosa",
            "Ficus benjamina var. nuda",
            "Ficus comosa",
            "Ficus cuspidatocaudata",
            "Ficus dictyophylla",
            "Ficus haematocarpa",
            "Ficus neglecta",
            "Ficus nepalensis",
            "Ficus nitida",
            "Ficus notobor",
            "Ficus nuda",
            "Ficus papyrifera",
            "Ficus parvifolia",
            "Ficus pendula",
            "Ficus pyrifolia",
            "Ficus reclinata",
            "Ficus retusa var. nitida",
            "Ficus striata",
            "Ficus umbrina",
            "Ficus xavieri",
            "Urostigma benjaminum",
            "Urostigma benjaminum var. nudum",
            "Urostigma haematocarpum",
            "Urostigma neglectum",
            "Urostigma nitidum",
            "Urostigma nudum"
          ],
          "propagation_methods": [
            "cuttings",
            "seeds"
          ]
        }
      }
    ]
  }
''';

  // Map formData = {
  //   "images": ["${base64Encode(bytes)}"],
  //   "modifiers": ["similar_images"],
  //   "plant_details": [
  //     "common_names",
  //     "url",
  //     "wiki_description",
  //     "taxonomy",
  //     "wiki_images",
  //     "synonyms",
  //     "name_authority",
  //     "propagation_methods",
  //     "edible_parts",
  //   ]
  // };

  // var bodyJson = json.encode(formData);

  // Response response = await http.post(url, body: bodyJson, headers: {
  //   "Api-Key": ApiKey.plant_id_key,
  //   "Content-Type": "application/json"
  // });

  // log("${response.body}");
  // final int statusCode = response.statusCode;
  // if (statusCode != 200) throw Exception('Failed to load plant');
  final plantsJson = await json.decode(plantJson);
  final plantsModels = PlantsModels.fromJson(plantsJson);

  return plantsModels;
}
