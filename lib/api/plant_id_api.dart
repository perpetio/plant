import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:plant/core/settings.dart';
import 'package:plant/models/plant_id.dart';
import 'package:plant/models/plant_net.dart';
import 'package:http/http.dart' as http;

Future getPlants(File image) async {
  Dio dio = new Dio();
  final Uint8List bytes = File(image.path).readAsBytesSync();
  final String url = 'https://api.plant.id/v2/identify';

  FormData formData = new FormData.fromMap(
    {
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
    },
  );

  http.post(url, body: formData, headers: {
    "Api-Key": ApiKey.plant_id_key,
    "Content-Type": "application/json"
  }).then((http.Response response) async {
    final int statusCode = response.statusCode;
    if (statusCode != 200) throw Exception('Failed to load plant');

    List<PlantId> results =
        jsonDecode(response.toString())['suggestions'].map<PlantId>((data) {
      return PlantDetect.fromJson(data);
    }).toList();

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
