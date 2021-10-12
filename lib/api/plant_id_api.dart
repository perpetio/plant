import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:plant/core/settings.dart';
import 'package:plant/models/plant_model.dart';
import 'package:http/http.dart' as http;

Future<List<PlantModel>> getPlants(File image) async {
  final Uint8List bytes = image.readAsBytesSync();
  final String url = 'https://api.plant.id/v2/identify';

  Map formData = {
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

  var bodyJson = json.encode(formData);

  Response response = await http.post(url, body: bodyJson, headers: {
    "Api-Key": ApiKey.plant_id_key,
    "Content-Type": "application/json"
  });

  log("${response.body}");
  final int statusCode = response.statusCode;
  if (statusCode != 200) throw Exception('Failed to load plant');

  List<PlantModel> results =
      jsonDecode(response.body)['suggestions'].map<PlantModel>((data) {
    return PlantModel.fromJson(data);
  }).toList();
  log('$results');

  return results;
}
