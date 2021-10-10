import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:plant/core/settings.dart';
import 'package:plant/models/plant.dart';
import 'package:http/http.dart' as http;

Future getPlants(File image) async {
  // Dio dio = new Dio();
  final Uint8List bytes = image.readAsBytesSync();
  final String url = 'https://api.plant.id/v2/identify';

  Map data = {
    "images": ["${base64Encode(bytes)}"],
    "modifiers": ["similar_images"],
    "plant_details": [
      "common_names",
      "url",
      "wiki_description",
      "taxonomy",
      "wiki_images",
      "synonyms",
      "name_authority",
      "propagation_methods",
      "edible_parts",
    ]
  };

  var bodyJson = json.encode(data);

  http.post(url, body: bodyJson, headers: {
    "Api-Key": ApiKey.plant_id_key,
    "Content-Type": "application/json"
  }).then((http.Response response) async {
    log("${response.body}");
    final int statusCode = response.statusCode;
    if (statusCode != 200) throw Exception('Failed to load plant');

    List<Plant> results =
        jsonDecode(response.body)['suggestions'].map<Plant>((data) {
      return Plant.fromJson(data);
    }).toList();

    log('$results');
    return results;
  });

  // Response response = await dio.post(
  //   "https://api.plant.id/v2/identify" + ApiKey.plant_id_key,
  //   data: formData,
  //   options: Options(),
  // );

  // print(response.data);

  // if (response.statusCode != 200) throw Exception('Failed to load plant');

  // List<PlantId> results =
  //     jsonDecode(response.toString())['suggestions'].map<PlantId>((data) {
  //   return PlantDetect.fromJson(data);
  // }).toList();

  // return results;
}
